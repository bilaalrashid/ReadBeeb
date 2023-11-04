//
//  BBCIPlayerAPINetworkController.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import Foundation
import Alamofire
import OSLog
import UIKit

struct BBCIPlayerAPINetworkController {

    static let baseUri = "https://open.live.bbc.co.uk"

    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpAdditionalHeaders = [
            // Pretend to be the BBC News app
            // Example: BBCNews/25339 (iPhone15,2; iOS 16.6) MediaSelectorClient/7.0.0 BBCHTTPClient/9.0.0
            "User-Agent": "BBCNews/25339 (\(UIDevice.current.modelIdentifier); \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)) MediaSelectorClient/7.0.0 BBCHTTPClient/9.0.0"
        ]
        return Session(configuration: configuration)
    }()

    static func fetchMediaConnections(for pid: String) async throws -> MediaSelectorResult {
        let url = self.baseUri + "/mediaselector/6/select/version/2.0/format/json/mediaset/mobile-phone-main/vpid/\(pid)/"
        Logger.network.debug("Requesting: \(url, privacy: .public)")
        let request = self.session.request(url).validate().serializingDecodable(MediaSelectorResult.self)
        return try await request.value
    }

}
