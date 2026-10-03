//
//  URL+IsBbc.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 21/10/2023.
//

import Foundation
import TLDExtract

extension URL {
    /// Path prefixes of BBC services that are not news.
    private static let notNewsServicePathPrefixes: Set<String> = ["iplayer", "sounds"]

    /// If the URL is on a domain owned by the BBC.
    var isBbc: Bool {
        let bbcDomains = ["bbc.co.uk", "bbci.co.uk", "bbc.com"]

        let extractor = TLDExtract()
        guard let extracted = extractor.parse(self) else { return false }
        guard let domain = extracted.rootDomain else { return false }

        return bbcDomains.contains(domain)
    }

    /// If the URL links to a news service, rather than another BBC service such as iPlayer or Sounds.
    var isNewsService: Bool {
        if self.isBbc {
            return !self.hasNotNewsServicePath
        }

        // Destination IDs are sometimes path-only values such as `/iplayer/episode/...`.
        return !(self.host == nil && self.hasNotNewsServicePath)
    }

    /// If the first path component matches a non-news BBC service.
    private var hasNotNewsServicePath: Bool {
        guard let firstPathComponent = self.path.split(separator: "/").first else {
            return false
        }

        return Self.notNewsServicePathPrefixes.contains(firstPathComponent.lowercased())
    }
}
