//
//  URL+Init.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import Foundation

extension URL {

    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }

}
