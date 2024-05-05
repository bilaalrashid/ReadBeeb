//
//  FDData+StoryPromos.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 25/11/2023.
//

import Foundation
import BbcNews

extension FDData {
    var storyPromos: Set<FDStoryPromo> {
        var storyPromos = Set<FDStoryPromo>()

        for item in self.structuredItems {
            switch item.body {
            case .billboard(let collection):
                storyPromos.formUnion(collection.items)
            case .hierarchicalCollection(let collection):
                storyPromos.formUnion(collection.items)
            case .simpleCollection(let collection):
                storyPromos.formUnion(collection.items)
            case .simplePromoGrid(let collection):
                storyPromos.formUnion(collection.items)
            case .carousel(let collection):
                storyPromos.formUnion(collection.items)
            case .storyPromo(let promo):
                storyPromos.insert(promo)
            default:
                break
            }
        }

        return storyPromos
    }
}
