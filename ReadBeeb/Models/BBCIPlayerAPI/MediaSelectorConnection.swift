//
//  MediaSelectorConnection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation

struct MediaSelectorConnection: Codable, Equatable, Hashable {
    let priority: String
    let authExpiresOffset: Int
    let dpw: String
    let `protocol`: String
    let supplier: String
    let authExpires: String
    let href: String
    let transferFormat: String

    /// A source link that uses a secure transmission protocol e.g. HTTPS instead of HTTP
    /// If the protocol is not supported, the insecure version is returned
    ///
    /// - Note: Currently only supports upgrading to HTTP to HTTPS
    var hrefSecure: String {
        // swiftlint:disable:next force_https
        return self.href.replacingOccurrences(of: "http://", with: "https://")
    }
}
