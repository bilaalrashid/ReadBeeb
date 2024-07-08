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
}
