import SwiftUI
import Combine
import AVFoundation

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
//
//struct ContentView: View {
//    
//    @StateObject private var speechManager = SpeechManager()
//    
//    private let word = "dog"
//    private let sentence = "The dog is happy"
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 24) {
//                
//                Text("Listen and Repeat")
//                    .font(.largeTitle.bold())
//                
//                // Card da palavra
//                VStack(spacing: 12) {
//                    Text("Word")
//                        .font(.headline)
//                        .foregroundStyle(.secondary)
//                    
//                    Text(word)
//                        .font(.system(size: 45, weight: .bold))
//                    
//                    Button {
//                        speechManager.speak(word)
//                    } label: {
//                        Label("Listen to the word", systemImage: "speaker.wave.2.fill")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//                .padding()
//                .background(.thinMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                
//                // Card da frase
//                VStack(spacing: 12) {
//                    Text("Sentence")
//                        .font(.headline)
//                        .foregroundStyle(.secondary)
//                    
//                    Text(sentence)
//                        .font(.title2.bold())
//                        .multilineTextAlignment(.center)
//                    
//                    Text("O dos está feliz")
//                        .font(.body)
//                        .foregroundStyle(.secondary)
//                    
//                    Button {
//                        speechManager.speak(sentence)
//                    } label: {
//                        Label("Listen to the sentence", systemImage: "speaker.wave.2.fill")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//                .padding()
//                .background(.thinMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
