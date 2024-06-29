//
//  FDItemGroup.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 29/06/2024.
//

import Foundation
import BbcNews

/// A `FDItem`, grouped with its corresponding `FDItem` header if one exists.
struct FDItemGroup {
    /// The header associated with the main body item.
    var header: FDItem?

    /// The main body item in a group.
    var body: FDItem
}
