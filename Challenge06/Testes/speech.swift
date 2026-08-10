import SwiftUI
import Speech

struct SpeechDemoView: View {
    
    @State var viewModel = SpeechService()

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.transcript.isEmpty ? "Toque no microfone e fale..." : viewModel.transcript)
                .padding()

            Button {
                viewModel.isRecording ? viewModel.stopRecording() : viewModel.startRecording()
            } label: {
                Image(systemName: viewModel.isRecording ? "mic.fill" : "mic")
                    .font(.system(size: 44))
                    .foregroundStyle(viewModel.isRecording ? .red : .accentColor)
            }
        }
        .padding()
        .onAppear { viewModel.requestPermission() }
    }
}

#Preview {
    SpeechDemoView()
}
