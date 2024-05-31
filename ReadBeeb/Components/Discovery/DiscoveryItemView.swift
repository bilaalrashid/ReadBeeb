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
    /// If the item has a header displayed above it.
    let hasHeader: Bool

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @Binding var destination: FDLinkDestination?

    var body: some View {
        switch item {
        case .collectionHeader(let item):
            CollectionHeader(item: item)
                .listRowSeparator(.hidden)
        case .billboard(let collection):
            StoryPromoCollection(
                collection: collection,
                collectionIndex: self.index,
                hasHeader: self.hasHeader,
                destination: self.$destination
            )
        case .hierarchicalCollection(let collection):
            StoryPromoCollection(
                collection: collection,
                collectionIndex: self.index,
                hasHeader: self.hasHeader,
                destination: self.$destination
            )
        case .simpleCollection(let collection):
            StoryPromoCollection(
                collection: collection,
                collectionIndex: self.index,
                hasHeader: self.hasHeader,
                destination: self.$destination
            )
        case .simplePromoGrid(let collection):
            StoryPromoCollection(
                collection: collection,
                collectionIndex: self.index,
                hasHeader: self.hasHeader,
                destination: self.$destination
            )
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
    DiscoveryItemView(item: .copyright(FDCopyright(lastUpdated: Date())), index: 0, hasHeader: false, destination: .constant(nil))
}
