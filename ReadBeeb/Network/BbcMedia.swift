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
    /// The base URI for the BBC
    static let baseUri = "https://open.live.bbc.co.uk"

    /// The session to perform network requests from
    let session: Session

    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpAdditionalHeaders = [
            // Pretend to be the BBC News app
            // Example: BBCNews/25339 (iPhone15,2; iOS 16.6) MediaSelectorClient/7.0.0 BBCHTTPClient/9.0.0
            // swiftlint:disable:next line_length force_https
            "User-Agent": "BBCNews/25339 (\(UIDevice.current.modelIdentifier); \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)) MediaSelectorClient/7.0.0 BBCHTTPClient/9.0.0"
        ]
        self.session = Session(configuration: configuration)
    }

    /// Returns a list of media selectors for a given media PID.
    ///
    /// - Parameter pid: The ID of the media item.
    /// - Returns: A list of media selectors for the media item.
    func fetchMediaConnections(for pid: String) async throws -> MediaSelectorResult {
        let url = BbcMedia.baseUri + "/mediaselector/6/select/version/2.0/format/json/mediaset/mobile-phone-main/vpid/\(pid)/"
        Logger.network.debug("Requesting: \(url, privacy: .public)")
        let request = self.session.request(url).validate().serializingDecodable(MediaSelectorResult.self)
        return try await request.value
    }
}
