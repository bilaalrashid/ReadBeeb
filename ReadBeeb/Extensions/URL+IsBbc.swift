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
    private static let otherServicePathPrefixes: Set<String> = ["iplayer", "sounds"]

    /// Shared public-suffix parser. Building it reads a 10,000-line list, so reuse one instance.
    /// We only call `parse()`, which does not modify the parser, so it is safe to mark as nonisolated.
    nonisolated(unsafe) private static let tldExtract = TLDExtract()

    /// If the URL is on a domain owned by the BBC.
    var isBbc: Bool {
        let bbcDomains = ["bbc.co.uk", "bbci.co.uk", "bbc.com"]

        guard let extracted = Self.tldExtract.parse(self) else { return false }
        guard let domain = extracted.rootDomain else { return false }

        return bbcDomains.contains(domain)
    }

    /// If the URL links to a news service, rather than another BBC service such as iPlayer or Sounds.
    var isNewsService: Bool {
        // Destination IDs can be either an absolute URL or a relative path, so don't validate the host.
        guard let service = self.path.split(separator: "/").first?.lowercased() else {
            return true
        }

        return !Self.otherServicePathPrefixes.contains(service)
    }
}
