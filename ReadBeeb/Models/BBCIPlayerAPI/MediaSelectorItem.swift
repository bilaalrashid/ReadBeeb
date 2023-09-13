//
//  MediaSelectorItem.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation

struct MediaSelectorItem: Codable, Equatable, Hashable {
    let width: String?
    let bitrate: String?
    let height: String?
    let service: String
    let connection: [MediaSelectorConnection]
    let kind: String
    let type: String
    let encoding: String
    let expires: String
}
