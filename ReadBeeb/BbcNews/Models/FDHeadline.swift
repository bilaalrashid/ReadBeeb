//
//  FDHeadline.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

struct FDHeadline: Codable, Equatable, Hashable {
    let type: String
    let text: String
    let lastUpdated: Int?
    let firstPublished: Int?
    let lastPublished: Int?
    let byline: FDHeadlineByline?
    let topic: FDTopic?
    let languageCode: String
    let readTimeMinutes: Int

    var published: Int? {
        return self.lastUpdated ?? self.lastPublished
    }
}

struct FDHeadlineByline: Codable, Equatable, Hashable {
    let name: String
    let purpose: String
}
