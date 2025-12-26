//
//  Secrets.swift
//  Velo
//
//  P0-1 Fix: Compile-time constants for API credentials
//  This file should be added to .gitignore for security
//

import Foundation

/// Secure configuration for API credentials
/// These are compile-time constants that work in production iOS builds
/// (unlike ProcessInfo.processInfo.environment which only works in Xcode debug schemes)
enum Secrets {
    // MARK: - Supabase Configuration

    #if DEBUG
    /// Development Supabase URL
    static let supabaseURL = "https://ycuxojvbqodicewurpxp.supabase.co"
    /// Development Supabase Anonymous Key (safe to include - protected by RLS)
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljdXhvanZicW9kaWNld3VycHhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4MDgwNDAsImV4cCI6MjA0OTM4NDA0MH0.placeholder_key_replace_with_actual"
    #else
    /// Production Supabase URL
    static let supabaseURL = "https://ycuxojvbqodicewurpxp.supabase.co"
    /// Production Supabase Anonymous Key (safe to include - protected by RLS)
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljdXhvanZicW9kaWNld3VycHhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4MDgwNDAsImV4cCI6MjA0OTM4NDA0MH0.placeholder_key_replace_with_actual"
    #endif

    // MARK: - RevenueCat Configuration

    #if DEBUG
    static let revenueCatAPIKey = "appl_placeholder_dev_key"
    #else
    static let revenueCatAPIKey = "appl_placeholder_prod_key"
    #endif

    // MARK: - Validation

    /// Check if all required secrets are configured
    static var isConfigured: Bool {
        !supabaseURL.isEmpty &&
        !supabaseAnonKey.isEmpty &&
        !supabaseAnonKey.contains("placeholder")
    }

    /// Error message when configuration is missing
    static var configurationError: String? {
        guard !isConfigured else { return nil }

        if supabaseURL.isEmpty {
            return "Supabase URL is not configured"
        }
        if supabaseAnonKey.isEmpty || supabaseAnonKey.contains("placeholder") {
            return "Supabase Anonymous Key is not configured"
        }
        return "Unknown configuration error"
    }
}
