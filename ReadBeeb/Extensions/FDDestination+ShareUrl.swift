//
//  FDDestination+ShareUrl.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import Foundation

extension FDLinkDestination {

    var shareUrl: URL? {
        guard let canShare = self.presentation.canShare, canShare else { return nil }

        switch self.sourceFormat {
        case "ABL":
            return URL(string: "https://bbc.co.uk/" + self.id)
        case "HTML":
            return URL(string: self.url)
        default:
            return nil
        }
    }

}
