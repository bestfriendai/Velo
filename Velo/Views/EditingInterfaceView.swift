//
//  EditingInterfaceView.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import SwiftUI

struct EditingInterfaceView: View {
    @State private var messageText = ""
    @State private var isRecording = false
    @State private var showBeforeAfter = false
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi! I'm ready to edit your photo. Just tell me what you'd like to change.", isUser: false)
    ]

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
                        .padding(.bottom, 180)
                }
            }
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: { showBeforeAfter.toggle() }) {
                HStack(spacing: 4) {
                    Image(systemName: showBeforeAfter ? "eye.fill" : "eye")
                    Text(showBeforeAfter ? "After" : "Before")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
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
            // Placeholder photo
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

            // Processing overlay
            if isRecording {
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
                SuggestionCard(icon: "eye", text: "Open closed eyes", color: .blue)
                SuggestionCard(icon: "sun.max", text: "Brighten image", color: .orange)
                SuggestionCard(icon: "sparkles", text: "Enhance colors", color: .purple)
                SuggestionCard(icon: "crop", text: "Remove background", color: .green)
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
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
                .padding()
            }
            .frame(height: 200)
            .background(Color(white: 0.05))

            Divider()
                .background(Color.white.opacity(0.2))

            // Input Bar
            HStack(spacing: 12) {
                TextField("Type what you want to change...", text: $messageText)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(24)
                    .foregroundColor(.white)

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .disabled(messageText.isEmpty)
                .opacity(messageText.isEmpty ? 0.5 : 1.0)
            }
            .padding()
            .background(Color(white: 0.05))
        }
    }

    // MARK: - Voice Button
    private var voiceButton: some View {
        Button(action: { isRecording.toggle() }) {
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

                if isRecording {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 90, height: 90)
                        .scaleEffect(isRecording ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isRecording)
                }

                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - Helper Functions
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        messages.append(ChatMessage(text: messageText, isUser: true))
        let userMessage = messageText
        messageText = ""

        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            messages.append(ChatMessage(text: "Got it! I'll \(userMessage.lowercased()) for you.", isUser: false))
        }
    }
}

// MARK: - Supporting Views
struct SuggestionCard: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        Button(action: {}) {
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

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

#Preview {
    EditingInterfaceView()
}
