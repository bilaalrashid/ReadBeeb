//
//  DiscoveryItemView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI
import BbcNews

struct DiscoveryItemView: View {
    let item: FDItem
    let index: Int

    var body: some View {
        switch item {
        case .collectionHeader(let item):
            CollectionHeader(item: item)
                .listRowSeparator(.hidden)
        case .billboard(let collection):
            StoryPromoCollection(collection: collection, collectionIndex: self.index)
        case .hierarchicalCollection(let collection):
            StoryPromoCollection(collection: collection, collectionIndex: self.index)
        case .simpleCollection(let collection):
            StoryPromoCollection(collection: collection, collectionIndex: self.index)
        case .simplePromoGrid(let collection):
            StoryPromoCollection(collection: collection, collectionIndex: self.index)
        case .carousel(let item):
            Carousel(item: item)
        case .chipList(let item):
            ChipList(item: item)
        case .copyright(let item):
            Copyright(item: item)
                .listRowSeparator(.hidden)
        default:
            EmptyView()
        }
    }
}

#Preview {
    DiscoveryItemView(item: .copyright(FDCopyright(type: "Copyright", lastUpdated: 0)), index: 0)
}
