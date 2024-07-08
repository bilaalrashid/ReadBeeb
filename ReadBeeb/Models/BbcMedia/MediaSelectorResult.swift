//
//  MediaSelectorResult.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation

/// A result from the API returning a list of selectors for a media item.
struct MediaSelectorResult: Codable, Equatable, Hashable {
    /// The list of media items.
    let media: [MediaSelectorItem]
}
