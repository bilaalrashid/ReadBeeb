//
//  TopicResult.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 30/09/2023.
//

import Foundation

/// A result of topics retrieved from the config JSON file.
final class TopicResult: Codable {
    /// A list of topics.
    var topics: [Topic] = []
}
