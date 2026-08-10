//
//  RecordingView.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 05/08/26.
//

import SwiftUI

struct RecordingView: View {
    @State private var coordinator = AppCoordinator()
    @State private var speechService = SpeechService()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                Color("light_yellow").ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Button {
//                        speechService.isRecording
//                            ? speechService.stopRecording()
//                            : speechService.startRecording()
                        coordinator.push(.detail)
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
                    DetailView(transcript: "peixe")
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
