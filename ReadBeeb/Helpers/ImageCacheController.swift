//
//  ImageCacheController.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import Kingfisher

struct ImageCacheController {
    func setMaximumCacheSize() {
        ImageCache.default.diskStorage.config.expiration = Constants.maximumImageCacheAge
    }

    func clearCache() {
        ImageCache.default.clearDiskCache()
    }

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
