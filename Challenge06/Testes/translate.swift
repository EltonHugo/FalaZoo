import SwiftUI
import Translation

struct TranslatorView: View {

    // Texto digitado pelo usuário
    @State private var textoOriginal = ""

    // Resultado da tradução
    @State private var textoTraduzido = ""

    // Configuração da sessão de tradução
    @State private var configuracao:
        TranslationSession.Configuration?

    // Controla o indicador de carregamento
    @State private var traduzindo = false

    // Português do Brasil
    private let idiomaOrigem =
        Locale.Language(identifier: "pt_BR")

    // Inglês
    private let idiomaDestino =
        Locale.Language(identifier: "en_US")

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Texto em português")
                        .font(.headline)

                    TextEditor(text: $textoOriginal)
                        .frame(minHeight: 140)
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray.opacity(0.4))
                        }

                    Button {
                        iniciarTraducao()
                    } label: {
                        HStack {
                            if traduzindo {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "translate")
                            }

                            Text(
                                traduzindo
                                ? "Traduzindo..."
                                : "Traduzir"
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        traduzindo ||
                        textoOriginal
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )

                    Text("Resultado em inglês")
                        .font(.headline)

                    GroupBox {
                        Text(
                            textoTraduzido.isEmpty
                            ? "A tradução aparecerá aqui."
                            : textoTraduzido
                        )
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 100,
                            alignment: .topLeading
                        )
                        .textSelection(.enabled)
                    }
                }
                .padding()
            }
            .navigationTitle("Tradutor")
        }
        .translationTask(configuracao) { sessao in
            await traduzir(usando: sessao)
        }
    }

    
}

#Preview {
    ContentView()
}
