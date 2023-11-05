//
//  URL+IsBBC.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 21/10/2023.
//

import Foundation
import TLDExtract

extension URL {
    var isBBC: Bool {
        let bbcDomains = ["bbc.co.uk", "bbci.co.uk", "bbc.com"]

        let extractor = TLDExtract()
        guard let extracted = extractor.parse(self) else { return false }
        guard let domain = extracted.rootDomain else { return false }

        return bbcDomains.contains(domain)
    }
}
