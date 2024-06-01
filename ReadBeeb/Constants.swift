//
//  Constants.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import Foundation
import SwiftUI
import Kingfisher

enum Constants {
    enum UserDefaultIdentifiers {
        static let postcodeIdentifier = "uk.co.bilaal.ReadBeeb.storage.postcode"
    }

    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "uk.co.bilaal.ReadBeeb"

    static let primaryColor = Constants.newsColor

    static let newsColor = Color(red: 184 / 255, green: 0, blue: 0)

    static let sportColor = Color(red: 255 / 255, green: 210 / 255, blue: 48 / 255)

    static let maximumImageCacheAge: StorageExpiration = .days(1)

    /// The default aspect ratio to use for an image.
    static let defaultImageAspectRatio = 1.77777777
}
