//
//  MediaSelectorResult+ValidMedia.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import Foundation

extension MediaSelectorResult {
    /// A list of media streams that ReadBeeb is able to stream, sorted by largest width first
    var validMedia: [MediaSelectorItem] {
        let valid = self.media.filter {
            $0.kind == "video" && $0.type == "video/mp4" && $0.encoding == "h264" && !$0.validConnection.isEmpty
        }

        return valid.sorted {
            Int($0.width ?? "") ?? 0 > Int($1.width ?? "") ?? 0
        }
    }
}

extension MediaSelectorItem {
    /// A list of connection streams that ReadBeeb is able to stream, sorted by highest priority first
    var validConnection: [MediaSelectorConnection] {
        let valid = self.connection.filter {
            $0.transferFormat == "hls"
        }

        return valid.sorted {
            Int($0.priority) ?? 0 > Int($1.priority) ?? 0
        }
    }
}
