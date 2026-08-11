//
//  SwiftUIView.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 06/08/26.
//

import SwiftUI
import Translation

struct DetailView: View {
    
    @Environment(AppCoordinator.self) var coordinator
    let transcript: String
    
    @State var viewModel = DetailViewModel()
    @StateObject private var speechManager = SpeechManager()
    @State var isLoading: Bool = true
    @State private var showAlert = false
    @State private var imageCreatorService = ImageCreatorService()
    @State private var speechService = SpeechService()
    
    var body: some View {
        
        ZStack {
            
            Color("light_yellow")
                .ignoresSafeArea()
            
            if isLoading {
                
                ProgressView()
                
            } else {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: Palavra e tradução
                    HStack(spacing: 20) {
                        
                        ZStack {
                            
                            Circle()
                                .fill(Color.gray)
                                .opacity(0.15)
                                .frame(width: 120, height: 120)
                            
                            Text(viewModel.emojiAnimal)
                                .font(.system(size: 58))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Button {
                                print("Botão para ouvir a pronúncia da palavra foi apertado")
                                speechManager.speak(viewModel.englishAnimal)
                            } label: {
                                
                                HStack(spacing: 8) {
                                    
                                    Text(viewModel.englishAnimal)
                                        .font(
                                            .system(
                                                size: viewModel.englishAnimal.count > 8 ? 28 : 30,
                                                weight: .bold,
                                                design: .rounded
                                            )
                                        )
                                        .lineLimit(1)
                                    
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(
                                            .system(
                                                size: 30,
                                                weight: .medium
                                            )
                                        )
                                }
                            }
                            .contentShape(Rectangle())
                            .foregroundStyle(.primary)
                            
                            Text(viewModel.animal)
                                .font(
                                    .system(
                                        size: 28,
                                        weight: .medium,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    
                    // MARK: Frase e tradução
                    // Altura reservada fixa para o bloco (2 linhas sempre, mesmo com 1),
                    // assim o restante do layout não "pula" dependendo do tamanho do texto.
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Button {
                            print("Botão para ouvir a pronúncia da frase foi apertado")
                            speechManager.speak(viewModel.englishText)
                        } label: {
                            
                            HStack(alignment: .top, spacing: 8) {
                                
                                Text(viewModel.englishText)
                                    .font(
                                        .system(
                                            size: 28,
                                            weight: .medium,
                                            design: .rounded
                                        )
                                    )
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .layoutPriority(1)
                                
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(
                                        .system(
                                            size: 30,
                                            weight: .medium
                                        )
                                    )
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        }
                        .contentShape(Rectangle())
                        .foregroundStyle(.primary)
                        
                        
                        Text(viewModel.text)
                            .font(
                                .system(
                                    size: 28,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.top, 16)
                    
                    
                    // MARK: Imagem gerada
                    // Sem altura fixa: a imagem preenche o espaço que sobrar até o botão,
                    // então a distância pro botão fica sempre igual, tenha 1 ou 2 linhas de texto em cima.
                    GeometryReader { geometry in
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.gray)
                                .opacity(0.15)
                            
                            if let generatedImage = imageCreatorService.generatedImage {
                                
                                Image(
                                    decorative: generatedImage,
                                    scale: 1
                                )
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )
                                .clipped()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 30)
                                )
                                
                            } else if imageCreatorService.isLoading {
                                
                                ProgressView()
                                
                            } else {
                                
                                Image(
                                    systemName: "photo.trianglebadge.exclamationmark"
                                )
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .frame(minHeight: 220, maxHeight: 460)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 28)
                .padding(.top, 4)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
        }
        
        // MARK: Botão inferior fixo
        .safeAreaInset(edge: .bottom) {
            
            if !isLoading {
                
                Button {
                    print("Botão para dizer outra palavra foi apertado")
                    coordinator.pop()
                } label: {
                    
                    Text("Dizer outra palavra")
                        .font(
                            .system(
                                size: 25,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(Color("light_brown"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 76)
                        .background {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color("beige"))
                        }
                }
                .padding(.horizontal, 28)
                .padding(.top, 8)
                .padding(.bottom, 6) // margem pequena e fixa até a borda, em vez de grudar
                .background(Color("light_yellow"))
            }
        }
        
        .task {
            
            speechService.stopRecording()
            
            await viewModel.setUp(inputText: transcript)
            
            let confidence =
                viewModel.animalClassifier.prediction?.confidence ?? 0.05
            
            if confidence <= 0.05 {
                
                showAlert.toggle()
                
            } else {
                
                await imageCreatorService.generateImage(
                    animalName: viewModel.englishAnimal
                )
                
                isLoading = false
            }
        }
        
        .alert(
            "O animal não foi reconhecido",
            isPresented: $showAlert
        ) {
            
            Button("Tentar Novamente", role: .cancel) {
                coordinator.pop()
            }
        }
    }
}


#Preview {
    DetailView(transcript: "cavalo")
        .environment(AppCoordinator())
}
