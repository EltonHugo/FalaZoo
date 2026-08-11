import Foundation
import Speech
import Observation
import AVFoundation

@Observable
@MainActor
final class SpeechService {
    private(set) var transcript = ""
    private(set) var isRecording = false
    
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private var task: SFSpeechRecognitionTask?
    
    private var silenceTimer: Timer?
    private let silenceTimeout: TimeInterval = 2.5
    
    deinit {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    /// Verifica e solicita as permissões necessárias de forma assíncrona antes de acessar a engine.
    func checkAndRequestPermissions() async -> Bool {
        let speechStatus = SFSpeechRecognizer.authorizationStatus()
        let speechGranted: Bool
        
        if speechStatus == .notDetermined {
            speechGranted = await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { status in
                    continuation.resume(returning: status == .authorized)
                }
            }
        } else {
            speechGranted = (speechStatus == .authorized)
        }
        
        guard speechGranted else { return false }
        
        let recordGranted: Bool
        if #available(iOS 17.0, *) {
            recordGranted = await AVAudioApplication.requestRecordPermission()
        } else {
            recordGranted = await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }
        
        return recordGranted
    }
    
    func startRecording() {
        Task {
            // 1. Garante que todas as permissões estejam concedidas antes de inicializar o hardware
            guard await checkAndRequestPermissions() else {
                print("Permissões de áudio ou reconhecimento de fala negadas.")
                return
            }
            
            guard let recognizer, recognizer.isAvailable else {
                print("Reconhecedor de fala indisponível.")
                return
            }
            
            if isRecording || audioEngine.isRunning {
                stopRecording()
            }
            
            transcript = ""
            
            // 2. Configuração do AVAudioSession
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Erro ao configurar AVAudioSession: \(error.localizedDescription)")
                return
            }
            
            let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
            
            let format = node.outputFormat(forBus: 0)
            guard format.sampleRate > 0 else {
                print("Erro: Formato de áudio inválido (0 Hz). Microfone não pronto.")
                stopRecording()
                return
            }
            
            let recordingRequest = SFSpeechAudioBufferRecognitionRequest()
            recordingRequest.shouldReportPartialResults = true
            self.request = recordingRequest
            
            // 3. Captura a referência local segura para uso na closure de áudio
            node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                recordingRequest.append(buffer)
            }
            
            do {
                audioEngine.prepare()
                try audioEngine.start()
                isRecording = true
                resetSilenceTimer()
                
                task = recognizer.recognitionTask(with: recordingRequest) { [weak self] result, error in
                    guard let self = self else { return }
                    
                    Task { @MainActor in
                        guard self.isRecording else { return }
                        
                        if let result = result {
                            self.transcript = result.bestTranscription.formattedString
                            self.resetSilenceTimer()
                        }
                        
                        if error != nil || (result?.isFinal ?? false) {
                            self.stopRecording()
                        }
                    }
                }
            } catch {
                print("Erro ao iniciar o motor de áudio: \(error.localizedDescription)")
                stopRecording()
            }
        }
    }
    
    func stopRecording() {
        silenceTimer?.invalidate()
        silenceTimer = nil
        
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        request?.endAudio()
        request = nil
        
        task?.cancel()
        task = nil
        
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        isRecording = false
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceTimeout, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.stopRecording()
            }
        }
    }
}
