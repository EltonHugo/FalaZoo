//
//  RecordingViewModel.swift
//  Challenge06
//

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
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioApplication.requestRecordPermission { _ in }
    }
    
    func startRecording() {
        guard let recognizer, recognizer.isAvailable else {
            print("Reconhecedor de fala indisponível.")
            return
        }
        
        // Se já estiver gravando ou com o motor ativo, interrompe primeiro
        if isRecording || audioEngine.isRunning {
            stopRecording()
        }
        
        transcript = ""
        
        // 1. Configura e ativa a AVAudioSession PRIMEIRO
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.duckOthers, .defaultToSpeaker])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Erro ao configurar AVAudioSession: \(error.localizedDescription)")
            return
        }
        
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        
        // 2. Captura e valida o formato de áudio da entrada
        let format = node.outputFormat(forBus: 0)
        guard format.sampleRate > 0 else {
            print("Erro: Formato de áudio inválido (0 Hz). O microfone não foi inicializado.")
            stopRecording()
            return
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { return }
        request.shouldReportPartialResults = true
        
        // 3. Instala o tap com segurança
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.request?.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            
            resetSilenceTimer()
            
            task = recognizer.recognitionTask(with: request) { [weak self] result, error in
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
        
        // Desativa a sessão de áudio para liberar o microfone
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        
        isRecording = false
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceTimeout, repeats: false) { _ in
            Task { @MainActor [weak self] in
                self?.stopRecording()
            }
        }
    }
}
