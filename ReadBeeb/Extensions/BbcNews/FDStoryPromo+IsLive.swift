//
//  FDStoryPromo+IsLive.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 08/07/2024.
//

import Foundation
import BbcNews

extension FDStoryPromo {
    var isLive: Bool {
        guard let badges = self.badges else {
            return false
        }

        return badges.contains { $0.type == .live }
    }

    /// If the promo links to a news service, rather than another BBC service such as iPlayer or Sounds.
    var isNewsService: Bool {
        self.link.destinations.allSatisfy { destination in
            guard destination.url.isNewsService else {
                return false
            }

            guard let idUrl = URL(string: destination.id) else {
                return true
            }

            return idUrl.isNewsService
        }
    }
}
