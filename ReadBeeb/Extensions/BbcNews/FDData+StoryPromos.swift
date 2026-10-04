//
//  FDData+StoryPromos.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 25/11/2023.
//

import Foundation
import BbcNews

extension FDData {
    /// All unique story promos contained in the result.
    var storyPromos: Set<FDStoryPromo> {
        var storyPromos = Set<FDStoryPromo>()

        for group in self.itemGroups {
            guard let promos = group.storyPromos else { continue }
            storyPromos.formUnion(promos)
        }

        return storyPromos
    }
}
