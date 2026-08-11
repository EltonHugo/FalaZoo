//import SwiftUI
//
//struct ContentVieww: View {
//
//    @StateObject private var viewModel =
//        AnimalClassifierViewModel()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 24) {
//
//                Text("Descubra o animal")
//                    .font(.largeTitle)
//                    .bold()
//
//                TextField(
//                    "Exemplo: meu cachorro correu no parque",
//                    text: $viewModel.inputText,
//                    axis: .vertical
//                )
//                .textFieldStyle(.roundedBorder)
//                .lineLimit(3...6)
//
//                Button("Identificar animal") {
//                    viewModel.identifyAnimal()
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(
//                    viewModel.inputText
//                        .trimmingCharacters(
//                            in: .whitespacesAndNewlines
//                        )
//                        .isEmpty
//                )
//
//                if let prediction = viewModel.prediction {
//                    if prediction.confidence < 0.5 {
//                        Text("Não está na lista!")
//                            .font(.title)
//                            .foregroundStyle(.secondary)
//                            .bold()
//                    } else {
//                        VStack(spacing: 10) {
//                            Text(prediction.emoji)
//                                .font(.system(size: 90))
//
//                            Text(prediction.animal.capitalized)
//                                .font(.title)
//                                .bold()
//
//                            Text(prediction.unicode)
//                                .foregroundStyle(.secondary)
//
//                            Text(
//                                "Confiança: \(prediction.confidence * 100, specifier: "%.1f")%"
//                            )
//                            .font(.caption)
//                            .foregroundStyle(.secondary)
//                        }
//                    }
//                }
//
//                if !viewModel.errorMessage.isEmpty {
//                    Text(viewModel.errorMessage)
//                        .foregroundStyle(.red)
//                        .multilineTextAlignment(.center)
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}
//
////#Preview {
////    ContentVieww(viewModel: <#T##arg#>)
////}
