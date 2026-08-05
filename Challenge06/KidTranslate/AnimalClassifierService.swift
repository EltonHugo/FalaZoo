import Foundation
import CoreML
import NaturalLanguage

struct AnimalPrediction {
    let animal: String
    let unicode: String
    let emoji: String
    let confidence: Double
}

enum AnimalClassifierError: LocalizedError {
    case emptyText
    case modelReturnedNoPrediction
    case invalidLabel(String)

    var errorDescription: String? {
        switch self {
        case .emptyText:
            return "Digite ou fale uma frase antes de continuar."

        case .modelReturnedNoPrediction:
            return "O modelo não conseguiu identificar um animal."

        case .invalidLabel(let label):
            return "O modelo retornou um rótulo inválido: \(label)"
        }
    }
}

final class AnimalClassifierService {

    private let model: NLModel

    init() throws {
        let configuration = MLModelConfiguration()

        // AnimalClassifier é o nome do arquivo:
        // AnimalClassifier.mlmodel
        let coreMLModel = try AnimalClassifier(
            configuration: configuration
        ).model

        self.model = try NLModel(mlModel: coreMLModel)
    }

    func classify(_ text: String) throws -> AnimalPrediction {
        let cleanedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedText.isEmpty else {
            throw AnimalClassifierError.emptyText
        }

        guard let label = model.predictedLabel(for: cleanedText) else {
            throw AnimalClassifierError.modelReturnedNoPrediction
        }

        let hypotheses = model.predictedLabelHypotheses(
            for: cleanedText,
            maximumCount: 1
        )

        let confidence = hypotheses[label] ?? 0

        guard let parsedLabel = Self.parseLabel(label) else {
            throw AnimalClassifierError.invalidLabel(label)
        }

        return AnimalPrediction(
            animal: parsedLabel.animal,
            unicode: parsedLabel.unicode,
            emoji: parsedLabel.emoji,
            confidence: confidence
        )
    }

    private static func parseLabel(
        _ label: String
    ) -> (animal: String, unicode: String, emoji: String)? {

        // Exemplo recebido:
        // cachorro U+1F436

        let parts = label.split(separator: " ")

        guard
            parts.count >= 2,
            let lastPart = parts.last
        else {
            return nil
        }

        let unicode = String(lastPart)

        guard unicode.hasPrefix("U+") else {
            return nil
        }

        let animal = parts
            .dropLast()
            .joined(separator: " ")

        let hexadecimal = String(unicode.dropFirst(2))

        guard
            let value = UInt32(hexadecimal, radix: 16),
            let scalar = UnicodeScalar(value)
        else {
            return nil
        }

        return (
            animal: animal,
            unicode: unicode,
            emoji: String(scalar)
        )
    }
}
