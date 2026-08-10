//
//  FoundationService.swift
//  Challenge06
//
//  Created by Elton Hugo Ferreira da Silva on 07/08/26.
//

import Foundation
import Observation
import FoundationModels

@Generable
struct KeywordExtraction: Equatable {
    @Guide(description: "A palavra exata retirada do texto de origem, sem alterações, sinônimos ou traduções. Deve ser sempre um substantivo que representa um animal.")
    let palavra: String
    
    @Guide(description: """
        Escolha apenas um destes valores:
        
        Sim → somente se a palavra for cachorro, gato, rato, cavalo ou coelho.
        
        Não → qualquer outro animal ou ausência de animal.
        """)
    let isAnimal: String
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

@Observable
class FoundationService {
    var inputText: String = ""
    var message: String = ""
    var isGenerating: Bool = false
    var errorMessage: String?
    var animal: String?
    // Sessão do modelo. Você pode passar instruções (system prompt) aqui se quiser.
    
    private let session = LanguageModelSession(
        instructions: """
            Crie uma frase simples em português usando o animal.

            Regras:
            - A frase deve ser adequada para crianças.
            - Use palavras simples e comuns.
            - A frase deve sempre ser no presente. 
            - A frase deve ter no máximo 4 palavras.
            - O animal deve ser o sujeito da frase.
            - Descreva uma ação ou característica simples.
            - Evite palavras difíceis e expressões complexas.
            - Retorne apenas a frase.
        """
    )
    
    func sendMessage(inputText: String) async -> String {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return "" }

        errorMessage = nil
        isGenerating = true
        defer { isGenerating = false }

        do {
            let response = try await session.respond(
                to: text
            )
            let result = response.content
            return result
        } catch {
            errorMessage = "Erro ao gerar resposta: \(error.localizedDescription)"
            return ""
        }
    }
}
