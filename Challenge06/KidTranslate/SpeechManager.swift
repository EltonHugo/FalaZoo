import SwiftUI
import Speech
import Combine

@MainActor
final class SpeechManager: ObservableObject {
    
    // Responsável por transformar o texto em áudio.
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String) {
        do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .default, options: .duckOthers)
                try session.setActive(true)
            } catch {
                print("Erro ao configurar sessão de áudio: \(error)")
            }
        // Evita que vários áudios sejam reproduzidos ao mesmo tempo.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Texto que será falado.
        let utterance = AVSpeechUtterance(string: text)
        
        // Procura primeiro por uma voz Enhanced ou Premium em inglês (EUA)
        let bestVoice = AVSpeechSynthesisVoice.speechVoices().first { voice in
            voice.language == "en-US" && (voice.quality == .enhanced || voice.quality == .premium)
        }
        
        // Atribui a voz encontrada (ou usa a padrão como fallback se nenhuma melhor for encontrada)
        utterance.voice = bestVoice ?? AVSpeechSynthesisVoice(language: "en-US")
        
        // Velocidade um pouco mais lenta para facilitar o aprendizado.
        utterance.rate = 0.5
        
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
}
