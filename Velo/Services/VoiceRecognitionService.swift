//
//  VoiceRecognitionService.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import Speech
import AVFoundation
import Combine

/// Voice recognition service wrapping SFSpeechRecognizer
@MainActor
class VoiceRecognitionService: ObservableObject {
    // MARK: - Published Properties
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var errorMessage: String?
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined

    // MARK: - Private Properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Constants.Voice.localeIdentifier))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    // MARK: - Initialization
    init() {
        checkAuthorizationStatus()
    }

    // MARK: - Authorization
    /// Request speech recognition authorization
    func requestAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                Task { @MainActor in
                    self.authorizationStatus = status
                    continuation.resume(returning: status == .authorized)
                }
            }
        }
    }

    /// Check current authorization status
    private func checkAuthorizationStatus() {
        authorizationStatus = SFSpeechRecognizer.authorizationStatus()
    }

    /// Check if speech recognition is available
    var isAvailable: Bool {
        return speechRecognizer?.isAvailable ?? false
    }

    // MARK: - Recording Control
    /// Start recording and transcribing
    func startRecording() async throws {
        // Cancel any ongoing recognition
        if recognitionTask != nil {
            stopRecording()
        }

        // Check authorization
        guard authorizationStatus == .authorized else {
            throw VoiceRecognitionError.notAuthorized
        }

        // Check availability
        guard isAvailable else {
            throw VoiceRecognitionError.notAvailable
        }

        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw VoiceRecognitionError.recognitionRequestFailed
        }

        recognitionRequest.shouldReportPartialResults = true

        // Configure audio engine
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        // Start audio engine
        audioEngine.prepare()
        try audioEngine.start()

        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            Task { @MainActor in
                if let result = result {
                    self.transcribedText = result.bestTranscription.formattedString
                }

                if error != nil || result?.isFinal == true {
                    self.stopRecording()
                }
            }
        }

        isRecording = true
        errorMessage = nil
    }

    /// Stop recording
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionRequest?.endAudio()
        recognitionRequest = nil

        recognitionTask?.cancel()
        recognitionTask = nil

        isRecording = false

        // Deactivate audio session
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    /// Clear transcribed text
    func clearTranscription() {
        transcribedText = ""
        errorMessage = nil
    }

    /// Toggle recording state
    func toggleRecording() async {
        if isRecording {
            stopRecording()
        } else {
            do {
                try await startRecording()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Error Types
enum VoiceRecognitionError: LocalizedError {
    case notAuthorized
    case notAvailable
    case recognitionRequestFailed

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Speech recognition not authorized. Please enable it in Settings."
        case .notAvailable:
            return "Speech recognition is not available on this device."
        case .recognitionRequestFailed:
            return "Failed to create recognition request."
        }
    }
}
