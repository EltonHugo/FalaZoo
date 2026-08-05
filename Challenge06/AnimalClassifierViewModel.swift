import Foundation
import Combine

@MainActor
final class AnimalClassifierViewModel: ObservableObject {

    @Published var inputText = ""
    @Published private(set) var prediction: AnimalPrediction?
    @Published private(set) var errorMessage = ""

    private let classifier: AnimalClassifierService?

    init() {
        do {
            self.classifier = try AnimalClassifierService()
        } catch {
            self.classifier = nil
            self.errorMessage = """
            Não foi possível carregar o modelo: \
            \(error.localizedDescription)
            """
        }
    }

    func identifyAnimal() {
        guard let classifier else {
            errorMessage = "O modelo não está disponível."
            return
        }

        do {
            prediction = try classifier.classify(inputText)
            errorMessage = ""
        } catch {
            prediction = nil
            errorMessage = error.localizedDescription
        }
    }
}
