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
    var textoOriginal = ""
    var textoTraduzido = ""
    var traduzindo = false
    var configuracao: TranslationSession.Configuration?
    
    private let idiomaOrigem = Locale.Language(identifier: "pt_BR")
    private let idiomaDestino = Locale.Language(identifier: "en_US")
    
    func translate(_ text: String) async -> String {
        let textoLimpo = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textoLimpo.isEmpty else { return "Digite alguma coisa." }
        do {
            let session = TranslationSession(installedSource: idiomaOrigem, target: idiomaDestino)
            let response = try await session.translate(textoLimpo)
            return response.targetText
        } catch {
            return "Erro na tradução."
        }
    }
    
    func iniciarTraducao() {
        let textoLimpo = textoOriginal.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !textoLimpo.isEmpty else {
            textoTraduzido = "Digite alguma coisa."
            return
        }

        traduzindo = true
        textoTraduzido = ""

        if configuracao == nil {
            configuracao = TranslationSession.Configuration(
                source: idiomaOrigem,
                target: idiomaDestino
            )
        } else {
            configuracao?.invalidate()
        }
    }

    func traduzir(usando sessao: TranslationSession) async {
        do {
            let resposta = try await sessao.translate(textoOriginal)
            
            await MainActor.run {
                textoTraduzido = resposta.targetText
                traduzindo = false
            }
        } catch {
            await MainActor.run {
                textoTraduzido = "Não foi possível traduzir: " + error.localizedDescription
                traduzindo = false
            }
        }
    }
}
