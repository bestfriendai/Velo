//
//  ErrorHandler.swift
//  Velo
//
//  P1-2 Fix: Centralized error handling
//

import Foundation
import SwiftUI
import Combine

// MARK: - App Error Types

/// Unified error type for the application
enum AppError: LocalizedError, Equatable {
    case network(underlying: String)
    case authentication(message: String)
    case validation(field: String, message: String)
    case quota(remaining: Int)
    case imageProcessing(message: String)
    case configuration(message: String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network(let message):
            return "Network error: \(message)"
        case .authentication(let message):
            return message
        case .validation(let field, let message):
            return "\(field): \(message)"
        case .quota(let remaining):
            return remaining == 0
                ? "You've used all your free edits this month. Upgrade to Pro for unlimited edits."
                : "You have \(remaining) edits remaining."
        case .imageProcessing(let message):
            return "Image processing failed: \(message)"
        case .configuration(let message):
            return "Configuration error: \(message)"
        case .unknown(let message):
            return "Something went wrong: \(message)"
        }
    }

    /// Whether the error can be recovered from (e.g., by retrying)
    var isRecoverable: Bool {
        switch self {
        case .network, .imageProcessing:
            return true
        case .authentication, .validation, .quota, .configuration, .unknown:
            return false
        }
    }

    /// Suggested action for the user
    var actionSuggestion: String? {
        switch self {
        case .network:
            return "Check your internet connection and try again."
        case .authentication:
            return "Please sign in to continue."
        case .validation:
            return "Please check your input and try again."
        case .quota:
            return "Upgrade to Pro for unlimited edits."
        case .imageProcessing:
            return "Try with a different image or command."
        case .configuration:
            return "Please contact support."
        case .unknown:
            return "Please try again later."
        }
    }

    // MARK: - Equatable

    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let l), .network(let r)): return l == r
        case (.authentication(let l), .authentication(let r)): return l == r
        case (.validation(let lf, let lm), .validation(let rf, let rm)): return lf == rf && lm == rm
        case (.quota(let l), .quota(let r)): return l == r
        case (.imageProcessing(let l), .imageProcessing(let r)): return l == r
        case (.configuration(let l), .configuration(let r)): return l == r
        case (.unknown(let l), .unknown(let r)): return l == r
        default: return false
        }
    }
}

// MARK: - Error Handler

/// Centralized error handler for the application
@MainActor
final class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()

    @Published var currentError: AppError?
    @Published var isShowingError = false

    private init() {}

    /// Handle an error and optionally display it to the user
    func handle(_ error: Error, context: String = "", showToUser: Bool = true) {
        let appError = mapError(error)

        // Log the error
        Logger.error("\(context.isEmpty ? "" : "[\(context)] ")\(appError.errorDescription ?? "Unknown error")", category: Logger.general)

        if showToUser {
            self.currentError = appError
            self.isShowingError = true
        }
    }

    /// Dismiss the current error
    func dismissError() {
        withAnimation {
            isShowingError = false
            currentError = nil
        }
    }

    /// Map any error to an AppError
    private func mapError(_ error: Error) -> AppError {
        // Handle SupabaseError
        if let supabaseError = error as? SupabaseError {
            return mapSupabaseError(supabaseError)
        }

        // Handle URLError
        if let urlError = error as? URLError {
            return .network(underlying: urlError.localizedDescription)
        }

        // Handle VoiceRecognitionError
        if let voiceError = error as? VoiceRecognitionError {
            return mapVoiceError(voiceError)
        }

        // Default case
        return .unknown(error.localizedDescription)
    }

    private func mapSupabaseError(_ error: SupabaseError) -> AppError {
        switch error {
        case .notAuthenticated:
            return .authentication(message: "Please sign in to continue")
        case .authenticationFailed(let message):
            return .authentication(message: message)
        case .databaseError(let message):
            return .network(underlying: message)
        case .quotaExceeded:
            return .quota(remaining: 0)
        case .imageProcessingFailed:
            return .imageProcessing(message: "Failed to process the image")
        case .brandKitLimitReached:
            return .quota(remaining: 0)
        case .notImplemented:
            return .unknown("This feature is coming soon")
        case .configurationError(let message):
            return .configuration(message: message)
        }
    }

    private func mapVoiceError(_ error: VoiceRecognitionError) -> AppError {
        switch error {
        case .notAuthorized:
            return .authentication(message: "Speech recognition permission denied")
        case .notAvailable:
            return .configuration(message: "Speech recognition is not available")
        case .recognitionRequestFailed:
            return .unknown("Voice recognition failed. Please try again.")
        }
    }
}

// MARK: - Error Alert View Modifier

struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorHandler = ErrorHandler.shared

    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.isShowingError) {
                Button("OK") {
                    errorHandler.dismissError()
                }

                if let error = errorHandler.currentError, error.isRecoverable {
                    Button("Retry") {
                        errorHandler.dismissError()
                        // Retry logic would be handled by the caller
                    }
                }
            } message: {
                if let error = errorHandler.currentError {
                    Text(errorAlertMessage(for: error))
                }
            }
    }

    private func errorAlertMessage(for error: AppError) -> String {
        var message = error.errorDescription ?? "An error occurred"
        if let suggestion = error.actionSuggestion {
            message += "\n\n\(suggestion)"
        }
        return message
    }
}

extension View {
    /// Add global error handling alert to a view
    func withErrorHandling() -> some View {
        modifier(ErrorAlertModifier())
    }
}
