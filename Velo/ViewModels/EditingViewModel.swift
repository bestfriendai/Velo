//
//  EditingViewModel.swift
//  Velo
//
//  Created by Ky Vu on 12/10/25.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import Speech

/// ViewModel for the editing interface with voice integration
@MainActor
class EditingViewModel: ObservableObject {
    // MARK: - Published Properties

    /// Current photo being edited
    @Published var currentImage: UIImage?

    /// Edited version of the photo
    @Published var editedImage: UIImage?

    /// Chat messages between user and AI
    @Published var messages: [ChatMessage] = []

    /// Current text input
    @Published var messageText = ""

    /// Whether we're currently processing an edit
    @Published var isProcessing = false

    /// Whether we're recording voice
    @Published var isRecording = false

    /// Whether to show before/after comparison
    @Published var showBeforeAfter = false

    /// Error message to display
    @Published var errorMessage: String?

    /// Suggested prompts based on image analysis
    @Published var suggestions: [EditSuggestion] = []

    /// Current edit session (for history)
    @Published var currentSession: EditSession?

    // MARK: - Private Properties

    private let supabaseService = SupabaseService.shared
    private let voiceService = VoiceRecognitionService()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(image: UIImage? = nil) {
        self.currentImage = image
        setupVoiceRecognition()
        setupInitialMessage()
        generateSuggestions()
    }

    // MARK: - Voice Recognition Setup

    private func setupVoiceRecognition() {
        // Listen to voice service transcription
        voiceService.$transcribedText
            .sink { [weak self] text in
                guard let self = self, !text.isEmpty else { return }
                self.messageText = text
            }
            .store(in: &cancellables)

        // Listen to recording state
        voiceService.$isRecording
            .sink { [weak self] recording in
                self?.isRecording = recording
            }
            .store(in: &cancellables)

        // Listen to errors
        voiceService.$errorMessage
            .sink { [weak self] error in
                if let error = error {
                    self?.errorMessage = error
                }
            }
            .store(in: &cancellables)
    }

    private func setupInitialMessage() {
        messages.append(ChatMessage(
            text: "Hi! I'm ready to edit your photo. Just tell me what you'd like to change.",
            isUser: false
        ))
    }

    // MARK: - Voice Actions

    /// Start voice recording
    func startVoiceRecording() async {
        Logger.info("Starting voice recording", category: Logger.voice)

        // Request authorization if needed
        if voiceService.authorizationStatus != .authorized {
            let authorized = await voiceService.requestAuthorization()
            if !authorized {
                errorMessage = "Speech recognition permission denied. Please enable it in Settings."
                return
            }
        }

        do {
            try await voiceService.startRecording()
        } catch {
            Logger.error("Failed to start recording: \(error.localizedDescription)", category: Logger.voice)
            errorMessage = "Failed to start recording: \(error.localizedDescription)"
        }
    }

    /// Stop voice recording
    func stopVoiceRecording() {
        Logger.info("Stopping voice recording", category: Logger.voice)
        voiceService.stopRecording()

        // Auto-send the transcribed message
        if !messageText.isEmpty {
            Task {
                await sendMessage()
            }
        }
    }

    /// Toggle voice recording on/off
    func toggleVoiceRecording() {
        Task {
            if isRecording {
                stopVoiceRecording()
            } else {
                await startVoiceRecording()
            }
        }
    }

    // MARK: - Message Actions

    /// Send a text or voice message
    func sendMessage() async {
        guard !messageText.isEmpty else { return }

        let userMessage = messageText
        Logger.info("Sending message: \(userMessage)", category: Logger.general)

        // Add user message to chat
        messages.append(ChatMessage(text: userMessage, isUser: true))
        messageText = ""

        // Process the edit request
        await processEdit(command: userMessage)
    }

    /// Apply a suggestion
    func applySuggestion(_ suggestion: EditSuggestion) {
        messageText = suggestion.promptText
        Task {
            await sendMessage()
        }
    }

    // MARK: - Image Processing

    private func processEdit(command: String) async {
        guard let image = currentImage ?? editedImage else {
            errorMessage = "No image to edit"
            return
        }

        isProcessing = true

        // Add AI "thinking" message
        messages.append(ChatMessage(
            text: "Let me work on that for you...",
            isUser: false
        ))

        do {
            Logger.info("Processing edit request", category: Logger.general)

            let response = try await supabaseService.processEdit(
                command: command,
                image: image
            )

            if response.success {
                // Download edited image
                if let imageUrl = response.editedImageUrl {
                    await downloadEditedImage(from: imageUrl)
                }

                // Update chat
                let remainingText = response.editsRemaining ?? 0 > 0
                    ? "\(response.editsRemaining!) edits remaining this month."
                    : "You've used all your free edits this month."

                messages.append(ChatMessage(
                    text: "Done! Your photo has been edited. \(remainingText)",
                    isUser: false
                ))

                Logger.info("Edit completed successfully", category: Logger.general)
            } else {
                throw SupabaseError.imageProcessingFailed
            }

        } catch {
            Logger.error("Edit failed: \(error.localizedDescription)", category: Logger.general)
            errorMessage = error.localizedDescription

            // Update chat with error
            messages.append(ChatMessage(
                text: "Sorry, I couldn't complete that edit. \(error.localizedDescription)",
                isUser: false
            ))
        }

        isProcessing = false
    }

    private func downloadEditedImage(from urlString: String) async {
        Logger.info("Downloading edited image", category: Logger.general)

        guard let url = URL(string: urlString) else {
            Logger.error("Invalid image URL", category: Logger.general)
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                self.editedImage = image
                showBeforeAfter = true
                Logger.info("Edited image downloaded successfully", category: Logger.general)
            }
        } catch {
            Logger.error("Failed to download image: \(error.localizedDescription)", category: Logger.general)
            errorMessage = "Failed to download edited image"
        }
    }

    // MARK: - Suggestions

    private func generateSuggestions() {
        // Generate contextual suggestions based on image analysis
        // For now, provide common suggestions
        suggestions = [
            EditSuggestion(
                icon: "eye",
                text: "Open closed eyes",
                promptText: "Open the closed eyes in this photo naturally",
                color: .blue
            ),
            EditSuggestion(
                icon: "sun.max",
                text: "Brighten image",
                promptText: "Brighten this photo naturally",
                color: .orange
            ),
            EditSuggestion(
                icon: "sparkles",
                text: "Enhance colors",
                promptText: "Enhance the colors in this photo",
                color: .purple
            ),
            EditSuggestion(
                icon: "crop",
                text: "Remove background",
                promptText: "Remove the background from this photo",
                color: .green
            )
        ]
    }

    // MARK: - Image Actions

    /// Save the edited image to photo library
    func saveEditedImage() {
        guard let image = editedImage else {
            errorMessage = "No edited image to save"
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        messages.append(ChatMessage(
            text: "Your edited photo has been saved to your library!",
            isUser: false
        ))
    }

    /// Share the edited image
    func shareEditedImage() -> UIImage? {
        return editedImage
    }

    /// Reset to original image
    func resetToOriginal() {
        editedImage = nil
        showBeforeAfter = false

        messages.append(ChatMessage(
            text: "Reset to original image. What would you like to change?",
            isUser: false
        ))
    }

    // MARK: - Cleanup

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Supporting Models

struct EditSuggestion: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let promptText: String
    let color: Color
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
