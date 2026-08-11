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
            Create a simple English sentence using the animal.

            Rules:

            * The sentence must be suitable for children.
            * Use simple and common words.
            * The sentence must always be in the present tense.
            * The sentence must contain a maximum of 4 words.
            * The animal must be the subject of the sentence.
            * Describe a simple action or characteristic.
            * Avoid difficult words and complex expressions.
            * Return only the sentence.
            * Remenber that sentence must contain just only 4 words
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
