//
//  MediaSelectorConnection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation

/// A method to connect to a remote media item.
struct MediaSelectorConnection: Codable, Equatable, Hashable {
    /// The priority of how the connection method should be favoured.
    let priority: String

    /// The number of seconds at which the connection method for the media item is no longer valid for.
    let authExpiresOffset: Int

    /// The DPW of the connection method.
    let dpw: String

    /// The network protocol used for fetching the media item.
    let protocolName: String

    /// The network hosting provider of the connection method.
    let supplier: String

    /// The time at which the connection method for the media item is no longer valid for.
    let authExpires: Date

    /// The link at which the contents of the media item is accessible at.
    let href: URL

    /// The format in which the contents of the media item is delivered in.
    let transferFormat: String

    /// A source link that uses a secure transmission protocol e.g. HTTPS instead of HTTP
    /// If the protocol is not supported, the insecure version is returned
    ///
    /// - Note: Currently only supports upgrading to HTTP to HTTPS
    var hrefSecure: URL? {
        var components = URLComponents(url: self.href, resolvingAgainstBaseURL: true)

        let scheme = components?.scheme
        // swiftlint:disable:next force_https
        components?.scheme = scheme?.replacingOccurrences(of: "http", with: "https")

        return components?.url
    }

    private enum CodingKeys: String, CodingKey {
        case priority, authExpiresOffset, dpw, protocolName = "protocol", supplier, authExpires, href, transferFormat
    }
}
