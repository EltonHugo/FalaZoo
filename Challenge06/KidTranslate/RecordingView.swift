//
//  RecordingView.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 05/08/26.
//

import SwiftUI

struct RecordingView: View {
    //MARK: Variáveis
    @State private var coordinator = AppCoordinator()
    @State private var speechService = SpeechService()
    
    // FIXME: Esta View re-renderiza duas vezes ao alternar o estado do Toggle
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                Color("light_yellow").ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Button {
                        Task {
                            // 1. Validação assíncrona da permissão
                            let hasPermission = await speechService.checkAndRequestPermissions()
                            guard hasPermission else {
                                // Notificar interface ou redirecionar para Configurações
                                return
                            }
                            
                            if speechService.isRecording {
                                speechService.stopRecording()
                            } else {
                                speechService.startRecording()
                            }
                        }
                    } label: {
                        Image(systemName:
                                speechService.isRecording
                              ? "microphone.fill"
                              : "microphone"
                        )
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(
                            speechService.isRecording
                            ? Color.red
                            : Color("light_brown")
                        )
                        .frame(width: 128, height: 128)
                        .background(
                            Circle().fill(Color("beige"))
                                .shadow(radius: 5, y: 3))
                    }
                    
                    
                    Text(speechService.isRecording
                         ? "Estou ouvindo..."
                         : "Toque no microfone\ne diga um animal"
                    )
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(height: 85)
                }
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .detail:
                    DetailView(transcript: speechService.transcript)
                case .recording:
                    RecordingView()
                }
            }
        }
        .environment(coordinator)
        .onChange(of: speechService.isRecording) { _, value in
            if !value { coordinator.push(.detail) }
        }
    }
}

#Preview {
    RecordingView()
}
