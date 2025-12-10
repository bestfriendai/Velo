//
//  Logger.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import os

/// Custom logger for Velo app
enum Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.velo"

    // MARK: - Log Categories
    static let general = os.Logger(subsystem: subsystem, category: "General")
    static let network = os.Logger(subsystem: subsystem, category: "Network")
    static let voice = os.Logger(subsystem: subsystem, category: "Voice")
    static let ui = os.Logger(subsystem: subsystem, category: "UI")
    static let auth = os.Logger(subsystem: subsystem, category: "Auth")
    static let subscription = os.Logger(subsystem: subsystem, category: "Subscription")

    // MARK: - Logging Functions

    /// Log debug message
    static func debug(_ message: String, category: os.Logger? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let logger = category ?? general
        logger.debug("\(fileName) [\(function):\(line)] \(message)")
        #endif
    }

    /// Log info message
    static func info(_ message: String, category: os.Logger? = nil) {
        let logger = category ?? general
        logger.info("\(message)")
    }

    /// Log error message
    static func error(_ message: String, error: Error? = nil, category: os.Logger? = nil) {
        let logger = category ?? general
        if let error = error {
            logger.error("\(message): \(error.localizedDescription)")
        } else {
            logger.error("\(message)")
        }
    }

    /// Log fault message (critical errors)
    static func fault(_ message: String, error: Error? = nil, category: os.Logger? = nil) {
        let logger = category ?? general
        if let error = error {
            logger.fault("\(message): \(error.localizedDescription)")
        } else {
            logger.fault("\(message)")
        }
    }

    /// Log analytics event (for future integration)
    static func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        #if DEBUG
        var message = "Event: \(eventName)"
        if let parameters = parameters {
            message += " | Parameters: \(parameters)"
        }
        general.info("\(message)")
        #endif

        // TODO: Integrate with analytics service (Mixpanel/Amplitude)
    }
}
