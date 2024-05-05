//
//  FDImage+Id.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 09/11/2023.
//

import Foundation
import BbcNews

extension FDImage: Identifiable {
    public var id: String {
        return self.source.url
    }
}
