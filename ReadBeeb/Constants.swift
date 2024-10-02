//
//  Constants.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import Foundation
import SwiftUI
@preconcurrency import Kingfisher

/// Global constants for the system.
enum Constants {
    /// Identifiers for UserDefault options.
    enum UserDefaultIdentifiers {
        /// The currently selected international service.
        static let service = "uk.co.bilaal.ReadBeeb.storage.service"

        /// The currently selected postcode area.
        static let postcodeIdentifier = "uk.co.bilaal.ReadBeeb.storage.postcode"
    }

    /// The bundle identifier of the app.
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "uk.co.bilaal.ReadBeeb"

    /// The primary theme color of the system.
    static let primaryColor = Constants.newsColor

    /// The color representing the BBC News brand.
    static let newsColor = Color(red: 184 / 255, green: 0, blue: 0)

    /// The color representing the BBC Sports brand.
    static let sportColor = Color(red: 255 / 255, green: 210 / 255, blue: 48 / 255)

    /// The maximum age of an image in the image cache.
    static let maximumImageCacheAge: StorageExpiration = .days(1)

    /// The default aspect ratio to use for an image.
    static let defaultImageAspectRatio = 1.77777777
}
