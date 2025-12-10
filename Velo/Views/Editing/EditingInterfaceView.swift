//
//  EditingInterfaceView.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//  Refactored with ViewModel on 12/10/25
//

import SwiftUI

struct EditingInterfaceView: View {
    @StateObject private var viewModel: EditingViewModel
    @Environment(\.dismiss) private var dismiss

    init(image: UIImage? = nil) {
        _viewModel = StateObject(wrappedValue: EditingViewModel(image: image))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                topBar

                // Photo Preview Area
                photoPreviewArea
                    .frame(maxHeight: .infinity)

                // AI Suggestion Cards
                suggestionCards

                // Chat Interface
                chatInterface
            }

            // Floating Voice Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    voiceButton
                        .padding(.trailing, 20)
                        .padding(.bottom: 180)
                }
            }

            // Error Alert
            if let error = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                        .padding()
                        .transition(.move(edge: .bottom))
                        .onTapGesture {
                            viewModel.errorMessage = nil
                        }
                }
            }
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: { viewModel.showBeforeAfter.toggle() }) {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.showBeforeAfter ? "eye.fill" : "eye")
                    Text(viewModel.showBeforeAfter ? "After" : "Before")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            }
            .disabled(viewModel.editedImage == nil)
            .opacity(viewModel.editedImage == nil ? 0.5 : 1.0)

            Spacer()

            Menu {
                Button(action: { viewModel.saveEditedImage() }) {
                    Label("Save to Library", systemImage: "square.and.arrow.down")
                }
                .disabled(viewModel.editedImage == nil)

                Button(action: { viewModel.resetToOriginal() }) {
                    Label("Reset to Original", systemImage: "arrow.counterclockwise")
                }
                .disabled(viewModel.editedImage == nil)

                Button(action: {}) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .disabled(viewModel.editedImage == nil)
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    // MARK: - Photo Preview
    private var photoPreviewArea: some View {
        ZStack {
            // Display image or placeholder
            if let image = viewModel.showBeforeAfter ? viewModel.currentImage : (viewModel.editedImage ?? viewModel.currentImage) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.opacity)
            } else {
                // Placeholder
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.5))
                    Text("Your Photo Here")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            // Processing overlay
            if viewModel.isProcessing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("Processing your request...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .cornerRadius(0)
    }

    // MARK: - AI Suggestions
    private var suggestionCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.suggestions) { suggestion in
                    SuggestionCard(
                        icon: suggestion.icon,
                        text: suggestion.text,
                        color: suggestion.color
                    ) {
                        viewModel.applySuggestion(suggestion)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(white: 0.1))
    }

    // MARK: - Chat Interface
    private var chatInterface: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            .frame(height: 200)
            .background(Color(white: 0.05))

            Divider()
                .background(Color.white.opacity(0.2))

            // Input Bar
            HStack(spacing: 12) {
                TextField("Type what you want to change...", text: $viewModel.messageText)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(24)
                    .foregroundColor(.white)
                    .disabled(viewModel.isProcessing || viewModel.isRecording)
                    .onSubmit {
                        Task {
                            await viewModel.sendMessage()
                        }
                    }

                Button(action: {
                    Task {
                        await viewModel.sendMessage()
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .disabled(viewModel.messageText.isEmpty || viewModel.isProcessing)
                .opacity(viewModel.messageText.isEmpty || viewModel.isProcessing ? 0.5 : 1.0)
            }
            .padding()
            .background(Color(white: 0.05))
        }
    }

    // MARK: - Voice Button
    private var voiceButton: some View {
        Button(action: { viewModel.toggleVoiceRecording() }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)

                if viewModel.isRecording {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 90, height: 90)
                        .scaleEffect(viewModel.isRecording ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: viewModel.isRecording)
                }

                Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
        .disabled(viewModel.isProcessing)
        .opacity(viewModel.isProcessing ? 0.5 : 1.0)
    }
}

// MARK: - Supporting Views
struct SuggestionCard: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(text)
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(color.opacity(0.3))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            Text(message.text)
                .font(.body)
                .padding(12)
                .background(message.isUser ? Color.blue : Color.white.opacity(0.15))
                .foregroundColor(.white)
                .cornerRadius(16)
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser { Spacer() }
        }
    }
}

#Preview {
    EditingInterfaceView()
}
