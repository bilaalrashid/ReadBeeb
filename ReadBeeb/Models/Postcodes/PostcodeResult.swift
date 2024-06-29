//
//  PostcodeResult.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import Foundation

/// A result of Uk postcode areas retrieved from the config JSON file.
struct PostcodeResult: Codable {
    /// The list of UK postcode areas.
    let postcodes: [Postcode]
}
