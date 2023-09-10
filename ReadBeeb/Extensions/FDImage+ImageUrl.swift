//
//  FDImage+ImageUrl.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

extension FDImage {

    var largestImageUrl: String? {
        if self.source.sizingMethod.type == "SPECIFIC_WIDTHS" {
            if let maxSize = self.source.sizingMethod.widths.last {
                let formattedUrl = self.source.url.replacingOccurrences(of: self.source.sizingMethod.widthToken, with: String(maxSize))
                return formattedUrl
            }
        } else {
            return self.source.url
        }

        return nil
    }

    func largestImageUrl(upTo maxWidth: Int) -> String? {
        if self.source.sizingMethod.type == "SPECIFIC_WIDTHS" {
            let allowedWidths = self.source.sizingMethod.widths.filter { $0 < maxWidth }
            if let maxAllowedWith = allowedWidths.last {
                let formattedUrl = self.source.url.replacingOccurrences(of: self.source.sizingMethod.widthToken, with: String(maxAllowedWith))
                return formattedUrl
            }
        } else {
            return self.source.url
        }

        return nil
    }

}
