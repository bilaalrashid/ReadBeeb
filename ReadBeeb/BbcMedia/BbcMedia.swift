//
//  BbcMedia.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation
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
        case invalidResponse(url: URL)

        /// A non-success HTTP response code was received by the caller.
        ///
        /// This is any response code outside of the 2xx range.
        case unsuccessfulStatusCode(url: URL, code: Int)

        /// A response was returned that was unable to be decoded into a type.
        case undecodableResponse(url: URL, type: Decodable.Type, underlyingError: DecodingError)

        /// A generic error encountered when performing a networking operation.
        case generic(underlyingError: Error)

        /// A human-readable description describing the error.
        public var description: String {
            switch self {
            case .noUrl:
                return "There was no URL to request"
            case .invalidUrl(let url):
                return "\(url) is not a valid URL"
            case .invalidResponse(let url):
                return "The response of the HTTP request to \(url) was invalid"
            case .unsuccessfulStatusCode(let url, let code):
                return "\(url) returned an unsuccessful HTTP response code (\(code))"
            case .undecodableResponse(let url, let type, let underlyingError):
                // Manually rewrite the error description to be more useful when unwrapped
                var description = ""

                switch underlyingError {
                case .dataCorrupted(let context):
                    description = "Data corrupted when decoding: \(context)"
                case .keyNotFound(let key, let context):
                    description = "Key \(key) not found for coding path '\(context.codingPath)': \(context.debugDescription)"
                case .valueNotFound(let value, let context):
                    description = "Value \(value) not found for coding path '\(context.codingPath)': \(context.debugDescription)"
                case .typeMismatch(let type, let context):
                    description = "Type \(type) mismatch for coding path '\(context.codingPath)': \(context.debugDescription)"
                @unknown default:
                    description = "Decoding error: \(underlyingError.localizedDescription)"
                }

                return "\(url) returned a response that was not decodable to \(type): \(description)"
            case .generic(let underlyingError):
                return underlyingError.localizedDescription.description
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
            case .undecodableResponse:
                return NSLocalizedString(self.description, comment: "Unable to decode response")
            case .generic(let underlyingError):
                return underlyingError.localizedDescription
            }
        }
    }

    /// The hostname at which the API host hosted at.
    static let hostname = "open.live.bbc.co.uk"

    /// The session to perform network requests from
    let session: URLSession

    /// Creates a new network controller for fetching media items.
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

    /// Returns a list of media selectors for a given media PID, throwing an error if one occurs.
    ///
    /// - Parameter pid: The ID of the media item.
    /// - Returns: A list of media selectors for the media item.
    func fetchMediaConnectionsThrowing(for pid: String) async throws -> MediaSelectorResult {
        return try await self.fetchMediaConnections(for: pid).get()
    }

    /// Returns a list of media selectors for a given media PID.
    ///
    /// - Parameter pid: The ID of the media item.
    /// - Returns: A list of media selectors for the media item.
    func fetchMediaConnections(for pid: String) async -> Result<MediaSelectorResult, NetworkError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = BbcMedia.hostname
        components.path = "/mediaselector/6/select/version/2.0/format/json/mediaset/mobile-phone-main/vpid/\(pid)"

        if let url = components.url {
            return await self.fetch(url: url)
        }

        return .failure(NetworkError.noUrl)
    }

    /// Performs a HTTP GET request to a provided URL, throwing an error if one occurs.
    ///
    /// - Parameter url: The URL to fetch.
    /// - Returns: The fetched result.
    public func fetchThrowing<T: Decodable>(url: URL) async throws -> T {
        return try await self.fetch(url: url).get()
    }

    /// Performs a HTTP GET request to a provided URL.
    ///
    /// - Parameter url: The URL to fetch.
    /// - Returns: The fetched result.
    public func fetch<T: Decodable>(url: URL) async -> Result<T, NetworkError> {
        #if canImport(OSLog)
        Logger.network.debug("Requesting: \(url, privacy: .public)")
        #endif

        do {
            let (data, response) = try await self.session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.invalidResponse(url: url))
            }

            // Redirects should already be resolved, so if we receive a 3xx here, we have encountered a problem and we can't meaningfully
            // decode the result to something without re-requesting, which ought to be handled by the caller.
            let success = 200..<300
            guard success.contains(httpResponse.statusCode) else {
                return .failure(NetworkError.unsuccessfulStatusCode(url: url, code: httpResponse.statusCode))
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let decodingResult = decoder.decodeWithoutThrowing(T.self, from: data)

            switch decodingResult {
            case .success(let decoded):
                return .success(decoded)
            case .failure(let error):
                if let error = error as? DecodingError {
                    return .failure(NetworkError.undecodableResponse(url: url, type: T.self, underlyingError: error))
                }

                return .failure(NetworkError.generic(underlyingError: error))
            }
        } catch let error {
            return .failure(NetworkError.generic(underlyingError: error))
        }
    }
}
