//
//  FDItemGroup.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 29/06/2024.
//

import Foundation
import BbcNews

/// A `FDItem`, grouped with its corresponding `FDItem` header if one exists.
struct FDItemGroup {
    /// The header associated with the main body item.
    var header: FDItem?

    /// The main body item in a group.
    var body: FDItem

    /// If the group still has content after hiding promos that link to non-news BBC services.
    ///
    /// Groups that are not collections of story promos, such as chip lists and copyright, remain visible.
    var hasVisiblePromos: Bool {
        guard let storyPromos = self.storyPromos else {
            return true
        }

        return storyPromos.contains(where: \.isNewsService)
    }

    /// The story promos in the group's body, if the body is a collection of promos.
    ///
    /// `FDData.storyPromos` reads this property, so the promo-bearing cases are not listed a second time.
    var storyPromos: [FDStoryPromo]? {
        switch self.body {
        case .billboard(let collection):
            return collection.storyPromos
        case .hierarchicalCollection(let collection):
            return collection.storyPromos
        case .simpleCollection(let collection):
            return collection.storyPromos
        case .simplePromoGrid(let collection):
            return collection.storyPromos
        case .carousel(let collection):
            return collection.storyPromos
        case .storyPromo(let promo):
            return [promo]
        default:
            return nil
        }
    }
}
