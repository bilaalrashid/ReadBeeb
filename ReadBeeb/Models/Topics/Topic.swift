//
//  Topic.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 30/09/2023.
//

import Foundation
import SwiftData

@Model
final class Topic: Codable {

    enum CodingKeys: CodingKey {
        case id, headline, subhead
    }

    @Attribute(.unique) var id: String
    var headline: String
    var subhead: String?

    init(id: String, headline: String, subhead: String? = nil) {
        self.id = id
        self.headline = headline
        self.subhead = subhead
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.headline = try container.decode(String.self, forKey: .id)
        self.subhead = try container.decode(String?.self, forKey: .id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.headline, forKey: .headline)
        try container.encode(self.subhead, forKey: .subhead)
    }

}
