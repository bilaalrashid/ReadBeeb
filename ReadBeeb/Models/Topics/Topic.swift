//
//  Topic.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 30/09/2023.
//

import Foundation
import SwiftData

/// A topic that a user can choose to subscribe to.
@Model
final class Topic: Codable {
    enum CodingKeys: CodingKey {
        case id, headline, subhead
    }

    /// The ID of the topic.
    @Attribute(.unique) var id: String

    /// The primary name of the topic.
    var headline: String

    /// A secondary description for the topic.
    var subhead: String?

    /// Creates a new topic.
    ///
    /// - Parameters:
    ///   - id: The ID of the topic.
    ///   - headline: The primary name of the topic.
    ///   - subhead: A secondary description for the topic.
    init(id: String, headline: String, subhead: String? = nil) {
        self.id = id
        self.headline = headline
        self.subhead = subhead
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.headline = try container.decode(String.self, forKey: .headline)
        self.subhead = try container.decode(String?.self, forKey: .subhead)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.headline, forKey: .headline)
        try container.encode(self.subhead, forKey: .subhead)
    }
}
