//import SwiftUI
//import FoundationModels
//
//struct ChatFoundationModelView: View {
//    @State private var inputText: String = ""
//    @State private var messages: [ChatMessage] = []
//    @State private var isGenerating: Bool = false
//    @State private var errorMessage: String?
//
//    // Sessão do modelo. Você pode passar instruções (system prompt) aqui se quiser.
//    private let session = LanguageModelSession(
//        instructions: """
//        Você recebe uma frase em português.
//
//        Sua tarefa é:
//
//        1. Encontrar o substantivo que representa um animal presente na frase.
//        2. A palavra deve ser copiada exatamente como aparece na frase.
//        3. Gerar o emoji correspondente.
//        4. Explicar rapidamente por que essa palavra representa o tema da frase.
//        5. Preencher isAnimal apenas com "Sim" ou "Não".
//
//        A resposta deve seguir esta regra:
//
//        isAnimal = "Sim" SOMENTE quando a palavra for exatamente uma destas:
//
//        - cachorro
//        - gato
//        - rato
//        - cavalo
//        - coelho
//
//        Qualquer outro animal (urso, raposa, leão, tigre, panda, galinha, etc.) deve receber:
//
//        isAnimal = "Não"
//
//        Nunca considere outros animais como pertencentes à lista.
//        """
//    )
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                // Lista de mensagens
//                ScrollViewReader { proxy in
//                    ScrollView {
//                        LazyVStack(alignment: .leading, spacing: 12) {
//                            ForEach(messages) { message in
//                                messageBubble(message)
//                                    .id(message.id)
//                            }
//
//                            if isGenerating {
//                                HStack {
//                                    ProgressView()
//                                    Text("Pensando...")
//                                        .foregroundStyle(.secondary)
//                                }
//                                .padding(.horizontal)
//                            }
//                        }
//                        .padding()
//                    }
//                    .onChange(of: messages.count) {
//                        if let last = messages.last {
//                            withAnimation {
//                                proxy.scrollTo(last.id, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
//
//                if let errorMessage {
//                    Text(errorMessage)
//                        .font(.footnote)
//                        .foregroundStyle(.red)
//                        .padding(.horizontal)
//                }
//
//                Divider()
//
//                // Caixa de texto + botão de enviar
//                HStack(spacing: 8) {
//                    TextField("Digite sua mensagem...", text: $inputText, axis: .vertical)
//                        .textFieldStyle(.roundedBorder)
//                        .lineLimit(1...4)
//                        .onSubmit(sendMessage)
//
//                    Button {
//                        sendMessage()
//                    } label: {
//                        Image(systemName: "arrow.up.circle.fill")
//                            .font(.system(size: 28))
//                    }
//                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isGenerating)
//                }
//                .padding()
//            }
//            .navigationTitle("Chat com o modelo")
//        }
//    }
//
//    @ViewBuilder
//    private func messageBubble(_ message: ChatMessage) -> some View {
//        HStack {
//            if message.isUser { Spacer(minLength: 40) }
//
//            Text(message.text)
//                .padding(10)
//                .background(message.isUser ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.15))
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//
//            if !message.isUser { Spacer(minLength: 40) }
//        }
//        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
//    }
//
//    private func sendMessage() {
//        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !text.isEmpty else { return }
//
//        errorMessage = nil
//        messages.append(ChatMessage(text: text, isUser: true))
//        inputText = ""
//        isGenerating = true
//
//        Task {
//            do {
//                let response = try await session.respond(
//                    to: text,
//                    generating: KeywordExtraction.self
//                )
//                let result = response.content
//                await MainActor.run {
//                    let formatted = "Palavra: \(result.palavra)\nÉ animal da lista?: \(result.isAnimal)"
//                    print(formatted)
//                    messages.append(ChatMessage(text: formatted, isUser: false))
//                    isGenerating = false
//                }
//            } catch {
//                await MainActor.run {
//                    errorMessage = "Erro ao gerar resposta: \(error.localizedDescription)"
//                    isGenerating = false
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ChatFoundationModelView()
//}
