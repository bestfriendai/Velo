//
//  Logger.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import os.log

/// Custom logger for Velo app
enum Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.velo"

    // MARK: - Log Categories
    static let general = OSLog(subsystem: subsystem, category: "General")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let voice = OSLog(subsystem: subsystem, category: "Voice")
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let auth = OSLog(subsystem: subsystem, category: "Auth")
    static let subscription = OSLog(subsystem: subsystem, category: "Subscription")

    // MARK: - Logging Functions

    /// Log debug message
    static func debug(_ message: String, category: OSLog = .general, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        os_log(.debug, log: category, "%{public}@ [%{public}@:%d] %{public}@", fileName, function, line, message)
        #endif
    }

    /// Log info message
    static func info(_ message: String, category: OSLog = .general) {
        os_log(.info, log: category, "%{public}@", message)
    }

    /// Log error message
    static func error(_ message: String, error: Error? = nil, category: OSLog = .general) {
        if let error = error {
            os_log(.error, log: category, "%{public}@: %{public}@", message, error.localizedDescription)
        } else {
            os_log(.error, log: category, "%{public}@", message)
        }
    }

    /// Log fault message (critical errors)
    static func fault(_ message: String, error: Error? = nil, category: OSLog = .general) {
        if let error = error {
            os_log(.fault, log: category, "%{public}@: %{public}@", message, error.localizedDescription)
        } else {
            os_log(.fault, log: category, "%{public}@", message)
        }
    }

    /// Log analytics event (for future integration)
    static func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        #if DEBUG
        var message = "Event: \(eventName)"
        if let parameters = parameters {
            message += " | Parameters: \(parameters)"
        }
        os_log(.info, log: .general, "%{public}@", message)
        #endif

        // TODO: Integrate with analytics service (Mixpanel/Amplitude)
    }
}
