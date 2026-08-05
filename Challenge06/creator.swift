import SwiftUI
import ImagePlayground

struct creator: View {
    @State private var generatedImage: CGImage?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            if let cgImage = generatedImage {
                Image(decorative: cgImage, scale: 1.0)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 280)
                    
                    if isLoading {
                        ProgressView("Gerando com Apple Intelligence...")
                    } else {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.tint)
                    }
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button("Gerar em Background") {
                Task {
                    await generateImageInternally()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }

    private func generateImageInternally() async {
        isLoading = true
        errorMessage = nil

        do {
            // Nota: ImageCreator está depreciado/restrito em versões recentes
            let imageCreator = try await ImageCreator()
            let style = ImagePlaygroundStyle.animation
            
            let images = imageCreator.images(
                for: [.text("Um cachorro com roupinha de circo")],
                style: style,
                limit: 1
            )

            for try await image in images {
                await MainActor.run {
                    self.generatedImage = image.cgImage
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Erro: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
