//
//  TranslateService.swift
//  Challenge06
//
//  Created by Elton Hugo Ferreira da Silva on 07/08/26.
//

import Foundation
import Observation
import Translation

@Observable
class TranslateService {
    var originalText = ""
    var translatedText = ""
    
    var inputLanguage = Locale.Language(identifier: "pt_BR")
    var outputLanguage = Locale.Language(identifier: "en_US")
    
    func translate(_ text: String) async -> String {
        let textoLimpo = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textoLimpo.isEmpty else { return "Digite alguma coisa." }
        do {
            let session = TranslationSession(installedSource: inputLanguage, target: outputLanguage)
            let response = try await session.translate(textoLimpo)
            return response.targetText
        } catch {
            return "Erro na tradução."
        }
    }
}
