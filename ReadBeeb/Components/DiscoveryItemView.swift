//
//  DiscoveryItemView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI

struct DiscoveryItemView: View {
    let item: FDItem

    var body: some View {
        switch item {
        case .collectionHeader(let item):
            CollectionHeader(item: item)
        case .billboard(let collection):
            StoryPromoCollection(collection: collection)
        case .hierarchicalCollection(let collection):
            StoryPromoCollection(collection: collection)
        case .simpleCollection(let collection):
            StoryPromoCollection(collection: collection)
        case .simplePromoGrid(let collection):
            StoryPromoCollection(collection: collection)
        case .carousel(let item):
            Carousel(item: item)
        case .chipList(let item):
            ChipList(item: item)
        case .copyright(let item):
            Copyright(item: item)
        default:
            EmptyView()
        }
    }
}

#Preview {
    DiscoveryItemView(item: .copyright(FDCopyright(type: "Copyright", lastUpdated: 0)))
}
