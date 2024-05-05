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
            case .billboard(let item):
                storyPromos.formUnion(item.items)
            case .hierarchicalCollection(let item):
                storyPromos.formUnion(item.items)
            case .simpleCollection(let item):
                storyPromos.formUnion(item.items)
            case .simplePromoGrid(let item):
                storyPromos.formUnion(item.items)
            case .carousel(let item):
                storyPromos.formUnion(item.items)
            case .storyPromo(let item):
                storyPromos.insert(item)
            default:
                break
            }
        }

        return storyPromos
    }
}
