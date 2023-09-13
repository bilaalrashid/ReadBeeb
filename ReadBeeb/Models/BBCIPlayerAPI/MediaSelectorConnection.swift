//
//  MediaSelectorConnection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation

struct MediaSelectorConnection: Codable, Equatable, Hashable {
    let priority: String
    let authExpiresOffset: Int
    let dpw: String
    let `protocol`: String
    let supplier: String
    let authExpires: String
    let href: String
    let transferFormat: String
}
