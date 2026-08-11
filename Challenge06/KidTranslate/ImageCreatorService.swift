//
//  SwiftUIView.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 07/08/26.
//

import SwiftUI
import ImagePlayground
import Observation

@Observable

class ImageCreatorService {
    
    var generatedImage: CGImage?
    var isLoading = false
    var errorMessage: String?
    
    @MainActor

    func generateImage(animalName: String) async {
        
        isLoading = true
        generatedImage = nil
        errorMessage = nil
        
        let prompt = "a detailed illustration of a \(animalName)"
        
        print("Animal recebido: \(animalName)")
        print("Prompt enviado para o ImageCreator: \(prompt)")
        
        do {
            let imageCreator = try await ImageCreator()
            
            let images = imageCreator.images(
                for: [.text(animalName)],
                style: .illustration,
                limit: 1
            )
            
            for try await image in images {
                generatedImage = image.cgImage
                print("✅ IMAGEM GERADA")
                break
            }
            
            if generatedImage == nil {
                errorMessage = "Nenhuma imagem foi gerada."
                print("⚠️ Terminou sem retornar imagem.")
            }
            
        } catch let error as ImageCreator.Error {
            
            print("❌ IMAGE CREATOR ERROR:")
            print(String(reflecting: error))
            
            errorMessage = "Erro: \(error.localizedDescription)"
            
        } catch {
            
            print("❌ OUTRO ERRO:")
            print(String(reflecting: error))
            
            errorMessage = "Erro: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
