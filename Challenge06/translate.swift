//import SwiftUI
//import Translation
//
//struct ContentView: View {
//
//    // Texto digitado pelo usuário
//    @State private var textoOriginal = ""
//
//    // Resultado da tradução
//    @State private var textoTraduzido = ""
//
//    // Configuração da sessão de tradução
//    @State private var configuracao:
//        TranslationSession.Configuration?
//
//    // Controla o indicador de carregamento
//    @State private var traduzindo = false
//
//    // Português do Brasil
//    private let idiomaOrigem =
//        Locale.Language(identifier: "pt_BR")
//
//    // Inglês
//    private let idiomaDestino =
//        Locale.Language(identifier: "en_US")
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//
//                    Text("Texto em português")
//                        .font(.headline)
//
//                    TextEditor(text: $textoOriginal)
//                        .frame(minHeight: 140)
//                        .padding(8)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(.gray.opacity(0.4))
//                        }
//
//                    Button {
//                        iniciarTraducao()
//                    } label: {
//                        HStack {
//                            if traduzindo {
//                                ProgressView()
//                                    .tint(.white)
//                            } else {
//                                Image(systemName: "translate")
//                            }
//
//                            Text(
//                                traduzindo
//                                ? "Traduzindo..."
//                                : "Traduzir"
//                            )
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .disabled(
//                        traduzindo ||
//                        textoOriginal
//                            .trimmingCharacters(
//                                in: .whitespacesAndNewlines
//                            )
//                            .isEmpty
//                    )
//
//                    Text("Resultado em inglês")
//                        .font(.headline)
//
//                    GroupBox {
//                        Text(
//                            textoTraduzido.isEmpty
//                            ? "A tradução aparecerá aqui."
//                            : textoTraduzido
//                        )
//                        .frame(
//                            maxWidth: .infinity,
//                            minHeight: 100,
//                            alignment: .topLeading
//                        )
//                        .textSelection(.enabled)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Tradutor")
//        }
//        .translationTask(configuracao) { sessao in
//            await traduzir(usando: sessao)
//        }
//    }
//
//    private func iniciarTraducao() {
//        let textoLimpo = textoOriginal
//            .trimmingCharacters(
//                in: .whitespacesAndNewlines
//            )
//
//        guard !textoLimpo.isEmpty else {
//            textoTraduzido = "Digite alguma coisa."
//            return
//        }
//
//        traduzindo = true
//        textoTraduzido = ""
//
//        if configuracao == nil {
//            configuracao = TranslationSession.Configuration(
//                source: idiomaOrigem,
//                target: idiomaDestino
//            )
//        } else {
//            // Faz a tarefa ser executada novamente
//            configuracao?.invalidate()
//        }
//    }
//
//    private func traduzir(
//        usando sessao: TranslationSession
//    ) async {
//        do {
//            let resposta = try await sessao.translate(
//                textoOriginal
//            )
//
//            await MainActor.run {
//                textoTraduzido = resposta.targetText
//                traduzindo = false
//            }
//        } catch {
//            await MainActor.run {
//                textoTraduzido =
//                    "Não foi possível traduzir: " +
//                    error.localizedDescription
//
//                traduzindo = false
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
