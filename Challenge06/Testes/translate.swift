//import SwiftUI
//import Translation
//
//struct TranslatorView: View {
//
//    @State var service = TranslateService()
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//
//                    Text("Texto em português")
//                        .font(.headline)
//
//                    TextEditor(text: $service.textoOriginal)
//                        .frame(minHeight: 140)
//                        .padding(8)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(.gray.opacity(0.4))
//                        }
//
//                    Button {
//                        service.iniciarTraducao()
//                    } label: {
//                        HStack {
//                            if service.traduzindo {
//                                ProgressView()
//                                    .tint(.white)
//                            } else {
//                                Image(systemName: "translate")
//                            }
//
//                            Text(
//                                service.traduzindo
//                                ? "Traduzindo..."
//                                : "Traduzir"
//                            )
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .disabled(
//                        service.traduzindo ||
//                        service.textoOriginal
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
//                            service.textoTraduzido.isEmpty
//                            ? "A tradução aparecerá aqui."
//                            : service.textoTraduzido
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
//        .translationTask(service.configuracao) { sessao in
//            await service.traduzir(usando: sessao)
//        }
//        .onAppear {
//            service.textoOriginal = "cachorro"
//            service.iniciarTraducao()
//        }
//    }
//
//    
//}
//
//#Preview {
//    TranslatorView()
//}
