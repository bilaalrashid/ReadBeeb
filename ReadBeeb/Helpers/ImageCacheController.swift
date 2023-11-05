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
}
