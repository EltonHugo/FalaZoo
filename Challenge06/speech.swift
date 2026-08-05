import SwiftUI
import Speech

struct SpeechDemoView: View {
    @State private var transcript = ""
    @State private var isRecording = false

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private let audioEngine = AVAudioEngine()
    @State private var request: SFSpeechAudioBufferRecognitionRequest?
    @State private var task: SFSpeechRecognitionTask?

    var body: some View {
        VStack(spacing: 24) {
            Text(transcript.isEmpty ? "Toque no microfone e fale..." : transcript)
                .padding()

            Button {
                isRecording ? stopRecording() : startRecording()
            } label: {
                Image(systemName: isRecording ? "mic.fill" : "mic")
                    .font(.system(size: 44))
                    .foregroundStyle(isRecording ? .red : .accentColor)
            }
        }
        .padding()
        .onAppear { requestPermission() }
    }

    private func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioApplication.requestRecordPermission { _ in }
    }

    private func startRecording() {
        let node = audioEngine.inputNode
        request = SFSpeechAudioBufferRecognitionRequest()

        node.installTap(onBus: 0, bufferSize: 1024, format: node.outputFormat(forBus: 0)) { buffer, _ in
            request?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true

        task = recognizer?.recognitionTask(with: request!) { result, _ in
            if let result {
                transcript = result.bestTranscription.formattedString
            }
        }
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        isRecording = false
    }
}

#Preview {
    SpeechDemoView()
}
