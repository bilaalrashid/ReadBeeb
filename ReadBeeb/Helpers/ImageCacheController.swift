//
//  ImageCacheController.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import Kingfisher

/// A controller for the cache that stores images loaded from remote locations.
struct ImageCacheController {
    /// Sets the size of the image cache to the maximum.
    func setMaximumCacheSize() {
        ImageCache.default.diskStorage.config.expiration = Constants.maximumImageCacheAge
    }

    /// Clears the image cache.
    func clearCache() {
        ImageCache.default.clearDiskCache()
    }

    /// Gets the current size of the image cache.
    ///
    /// - Returns: The size of the image cache.
    func getCacheSize() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    continuation.resume(returning: Int(size))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
