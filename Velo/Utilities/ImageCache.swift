//
//  ImageCache.swift
//  Velo
//
//  PERF-2 Fix: Image caching with NSCache
//

import UIKit

/// Thread-safe image cache using actor pattern
actor ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    private var inFlightRequests: [String: Task<UIImage, Error>] = [:]

    private init() {
        // Configure cache limits
        cache.countLimit = 50 // Max 50 images
        cache.totalCostLimit = 100 * 1024 * 1024 // 100 MB
    }

    // MARK: - Cache Operations

    /// Get an image from cache
    func get(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    /// Store an image in cache
    func set(_ image: UIImage, for key: String) {
        // Calculate approximate cost in bytes
        let cost = Int(image.size.width * image.size.height * 4) // 4 bytes per pixel (RGBA)
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }

    /// Remove an image from cache
    func remove(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    /// Clear all cached images
    func clearAll() {
        cache.removeAllObjects()
        inFlightRequests.removeAll()
    }

    // MARK: - Fetch Operations

    /// Fetch an image from URL with caching
    func image(for urlString: String) async throws -> UIImage {
        // Check cache first
        if let cached = cache.object(forKey: urlString as NSString) {
            Logger.debug("Image cache hit for: \(urlString.prefix(50))...", category: Logger.network)
            return cached
        }

        // Check if already fetching
        if let existingTask = inFlightRequests[urlString] {
            Logger.debug("Image fetch already in flight for: \(urlString.prefix(50))...", category: Logger.network)
            return try await existingTask.value
        }

        // Create new fetch task
        let task = Task<UIImage, Error> {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            Logger.debug("Fetching image from: \(urlString.prefix(50))...", category: Logger.network)

            let (data, response) = try await URLSession.shared.data(from: url)

            // Validate response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }

            return image
        }

        inFlightRequests[urlString] = task

        do {
            let image = try await task.value

            // Cache the result
            let cost = Int(image.size.width * image.size.height * 4)
            cache.setObject(image, forKey: urlString as NSString, cost: cost)

            // Clean up in-flight request
            inFlightRequests[urlString] = nil

            Logger.debug("Image cached successfully for: \(urlString.prefix(50))...", category: Logger.network)
            return image

        } catch {
            // Clean up in-flight request on error
            inFlightRequests[urlString] = nil
            throw error
        }
    }

    /// Prefetch images for URLs
    func prefetch(_ urlStrings: [String]) {
        for urlString in urlStrings {
            Task {
                do {
                    _ = try await image(for: urlString)
                } catch {
                    Logger.debug("Prefetch failed for: \(urlString.prefix(50))...", category: Logger.network)
                }
            }
        }
    }
}

// MARK: - UIImage Extension for Processing

extension UIImage {
    /// Resize image on a background thread
    func resizedAsync(to maxDimension: CGFloat) async -> UIImage? {
        await Task.detached(priority: .userInitiated) {
            self.resized(to: maxDimension)
        }.value
    }

    /// Get JPEG data on a background thread
    func jpegDataAsync(compressionQuality: CGFloat) async -> Data? {
        await Task.detached(priority: .userInitiated) {
            self.jpegData(compressionQuality: compressionQuality)
        }.value
    }

    /// Get base64 encoded JPEG on a background thread (PERF-1 fix)
    func base64EncodedJPEGAsync(compressionQuality: CGFloat = 0.8, maxDimension: CGFloat = 2048) async throws -> String {
        try await Task.detached(priority: .userInitiated) {
            // Resize if needed
            let resized = self.resized(to: maxDimension) ?? self

            guard let imageData = resized.jpegData(compressionQuality: compressionQuality) else {
                throw AppError.imageProcessing(message: "Failed to encode image")
            }

            return imageData.base64EncodedString()
        }.value
    }
}
