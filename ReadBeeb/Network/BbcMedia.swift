//
//  BbcMedia.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation
import Alamofire
import OSLog
import UIKit

/// A network controller to fetch media items.
struct BbcMedia {
    /// An error occurred during a networking operation.
    enum NetworkError: Error, LocalizedError, CustomStringConvertible {
        /// No URL was provided to the caller.
        case noUrl

        /// An invalid URL was provided to the caller.
        case invalidUrl(url: String)

        /// A corrupt response was returned by the server.
        case invalidResponse

        /// A non-success HTTP response code was received by the caller.
        ///
        /// This is any response code outside of the 2xx range.
        case unsuccessfulStatusCode(code: Int)

        /// A human-readable description describing the error.
        public var description: String {
            switch self {
            case .noUrl:
                return "There was no URL to request"
            case .invalidUrl(let url):
                return "\(url) is not a valid URL"
            case .invalidResponse:
                return "The response to the HTTP request was invalid"
            case .unsuccessfulStatusCode(let code):
                return "The HTTP response gave an unsuccessful response code (\(code))"
            }
        }

        /// A localized message describing what error occurred.
        public var errorDescription: String? {
            switch self {
            case .noUrl:
                return NSLocalizedString(self.description, comment: "No URL")
            case .invalidUrl:
                return NSLocalizedString(self.description, comment: "Invalid URL")
            case .invalidResponse:
                return NSLocalizedString(self.description, comment: "Invalid HTTP response")
            case .unsuccessfulStatusCode:
                return NSLocalizedString(self.description, comment: "Unsuccessful HTTP request")
            }
        }
    }

    /// The hostname at which the API host hosted at.
    static let hostname = "https://open.live.bbc.co.uk"

    /// The session to perform network requests from
    let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            // Pretend to be the BBC News app
            // Example: BBCNews/25339 (iPhone15,2; iOS 16.6) MediaSelectorClient/7.0.0 BBCHTTPClient/9.0.0
            // swiftlint:disable:next line_length force_https
            "User-Agent": "BBCNews/25339 (\(UIDevice.current.modelIdentifier); \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)) MediaSelectorClient/7.0.0 BBCHTTPClient/9.0.0"
        ]
        self.session = URLSession(configuration: configuration)
    }

    /// Returns a list of media selectors for a given media PID.
    ///
    /// - Parameter pid: The ID of the media item.
    /// - Returns: A list of media selectors for the media item.
    func fetchMediaConnections(for pid: String) async throws -> MediaSelectorResult {
        var components = URLComponents()
        components.scheme = "https"
        components.host = BbcMedia.hostname
        components.path = "/mediaselector/6/select/version/2.0/format/json/mediaset/mobile-phone-main/vpid/\(pid)"

        if let url = components.url {
            return try await self.fetch(url: url)
        }

        throw NetworkError.noUrl
    }

    /// Performs a HTTP GET request to a provided URL.
    ///
    /// - Parameter url: The URL to fetch.
    /// - Returns: The fetched result.
    public func fetch<T: Decodable>(url: URL) async throws -> T {
        #if canImport(OSLog)
        Logger.network.debug("Requesting: \(url, privacy: .public)")
        #endif

        let (data, response) = try await self.session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        // Redirects should already be resolved, so if we receive a 3xx here, we have encountered a problem and we can't meaningfully
        // decode the result to something without re-requesting, which ought to be handled by the caller.
        let success = 200..<300
        guard success.contains(httpResponse.statusCode) else {
            throw NetworkError.unsuccessfulStatusCode(code: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970

        return try decoder.decode(T.self, from: data)
    }
}
