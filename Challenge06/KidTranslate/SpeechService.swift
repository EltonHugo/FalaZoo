//
//  RecordingViewModel.swift
//  Challenge06
//
//  Created by Elton Hugo Ferreira da Silva on 05/08/26.
//

import Foundation
import Speech
import Observation

@Observable
final class SpeechService {
    private(set) var transcript = ""
    private(set) var isRecording = false
    
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private var task: SFSpeechRecognitionTask?
    
    private var silenceTimer: Timer?
    private let silenceTimeout: TimeInterval = 2.5
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioApplication.requestRecordPermission { _ in }
    }
    
    func startRecording() {
        if audioEngine.isRunning {
            stopRecording()
        }
        
        transcript = ""
        
        let node = audioEngine.inputNode
        request = SFSpeechAudioBufferRecognitionRequest()
        
        node.installTap(onBus: 0, bufferSize: 1024, format: node.outputFormat(forBus: 0)) { [self] buffer, _ in
            request?.append(buffer)
        }
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            
            // Inicia o timer de silêncio inicial
            resetSilenceTimer()
            
            task = recognizer?.recognitionTask(with: request!) { [weak self] result, error in
                guard let self, self.isRecording else { return }
                
                if let result {
                    self.transcript = result.bestTranscription.formattedString
                    self.resetSilenceTimer()
                }
                
                if error != nil || (result?.isFinal ?? false) {
                    self.stopRecording()
                }
            }
        } catch {
            print("Erro ao iniciar o motor de áudio: \(error.localizedDescription)")
            stopRecording()
        }
    }
    
    func stopRecording() {
        isRecording = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceTimeout, repeats: false) { [self] _ in
            self.stopRecording()
        }
    }
}
