//
//  URL+Identifiable.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 21/10/2023.
//

import Foundation

extension URL: Identifiable {
    public var id: String {
        return self.absoluteString
    }
}
