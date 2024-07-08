//
//  URL+Identifiable.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 21/10/2023.
//

import Foundation

extension URL: @retroactive Identifiable {
    /// A wrapper around `absoluteString` to conform `URL` to identifiable.
    public var id: String {
        return self.absoluteString
    }
}
