//
//  SwiftUIView.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 06/08/26.
//

import SwiftUI

struct DetailView: View {
    
//    @State private var viewModel = DetailViewModel()
    @State private var imageCreatorService = ImageCreatorService()
    
    //    @Environment(AppCoordinator.self) var coordinator
    
    var body: some View {
        ZStack{
            Color("light_yellow")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: Palavra e traducão
                HStack(spacing: 20){
                    ZStack{
                        Circle()
                            .fill(Color.gray)
                            .opacity(0.15)
                            .frame(width: 120, height: 120)
                        Text("\u{1F436}")
                            .font(.system(size: 58))
                    }
                    
                    VStack(alignment: .leading, spacing: 4){
                            Button{
                                print("Botão para ouvir a pronúncia da palavra foi apertado")
                            }label:{
                                Text("DOG")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 30, weight: .medium))
                            }
                            .contentShape(Rectangle()) //faz toda a área da palavra e do ícone ser clicável
                            .foregroundStyle(.primary)

                        Text("Cachorro")
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    Spacer() // faz com que nao quebre o layout
                } // fim da mark hstack da palavra e traducao
                
                // MARK: Frase e tradução
                VStack(alignment: .leading, spacing: 8){
                        Button{
                            print("Botão para ouvir a pronúncia da frase foi apertado")
                        } label: {
                            Text(#""The dog is happy""#)
                                .font(.system(size: 28, weight: .medium, design: .rounded))
                                
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 30, weight: .medium))
                                
                        }
                        .contentShape(Rectangle())
                        .foregroundStyle(.primary)
//                        .foregroundStyle(.black)
                    
                    Text(#""O cachorro está feliz""#)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                } // fim da mark vstack de frase e traducao
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 34)
                
                //MARK: Imagem gerada
                GeometryReader { geometry in
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.gray)
                            .opacity(0.15)
                        
                        if let generatedImage = imageCreatorService.generatedImage{
                            Image(decorative: generatedImage, scale: 1)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        } else if imageCreatorService.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "photo.trianglebadge.exclamationmark")
                                .font(.system(size:40))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(height: 380)
                .padding(.top, 28)
                .padding(.bottom, 20)
                
                Spacer()
                
                
                // MARK: Botão inferior
                Button{
                    print("Botão para dizer outra palavra foi apertado")
//                    coordinator.pop()
                } label: {
                    Text("Dizer outra palavra")
                        .font(.system(size: 25, weight: .medium, design: .rounded))
                        .foregroundStyle(Color("light_brown"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 86)
                        .background{
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color("beige"))
                        }
                }
                
                
            } // fim da vstack
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .task {
            await imageCreatorService.generateImage(animalName: "cachorro")
        }
    }
}
#Preview {
    DetailView()
}
//ViewModel.generatedImage
//cordinator.pop() p voltar p o inicio
