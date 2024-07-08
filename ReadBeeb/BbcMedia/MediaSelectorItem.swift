//
//  MediaSelectorItem.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation

/// A remote media item.
struct MediaSelectorItem: Codable, Equatable, Hashable {
    /// The width of the media item.
    let width: String?

    /// The bitrate of the media item.
    let bitrate: String?

    /// The height of the media item.
    let height: String?

    /// The service of the media item.
    let service: String

    /// A list of network methods to access the media item.
    let connection: [MediaSelectorConnection]

    /// The type of the media item.
    let kind: String

    /// The IANA media type of the media file.
    let type: String

    /// The encoding of the media item.
    let encoding: String

    /// The date that the connection for the media item expires.
    let expires: String
}
