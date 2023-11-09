//
//  FDImage+Id.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 09/11/2023.
//

import Foundation

extension FDImage: Identifiable {
    var id: String {
        return self.source.url
    }
}
