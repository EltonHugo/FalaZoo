import SwiftUI
import ImagePlayground

struct AnimalImageTestView: View {
    let animalName: String
    
    @State private var generatedImage: CGImage?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.12))
                
                if let generatedImage {
                    Image(decorative: generatedImage, scale: 1.0)
                        .resizable()
                        .scaledToFit()
                        .padding(16)
                } else if isLoading {
                    ProgressView("Gerando imagem...")
                } else if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 300, height: 300)
        }
        .padding()
        .task {
            await generateAnimalImage()
        }
    }

    @MainActor
    private func generateAnimalImage() async {
        isLoading = true
        errorMessage = nil
        generatedImage = nil

        let prompt = """
        Um único \(animalName) em estilo de desenho infantil.
        Mostrar somente o animal, inteiro, centralizado e sozinho.
        Usar formas arredondadas, aparência amigável, cores suaves e contornos limpos.
        Estilo de ilustração infantil, bonito e educativo.
        Fundo simples e claro, sem texto, sem cenário complexo e sem outros animais.
        """

        do {
            let imageCreator = try await ImageCreator()

            let images = imageCreator.images(
                for: [.text(prompt)],
                style: .illustration,
                limit: 1
            )

            var receivedImage = false

            for try await image in images {
                self.generatedImage = image.cgImage
                receivedImage = true
                break
            }

            if !receivedImage {
                self.errorMessage = "Nenhuma imagem foi gerada."
            }

        } catch {
            self.errorMessage = "Erro ao gerar imagem: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    AnimalImageTestView(animalName: "cachorro")
}
