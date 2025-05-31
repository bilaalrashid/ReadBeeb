//
//  DiscoveryItemView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a individual item in a discovery page.
struct DiscoveryItemView: View {
    /// The item in the page to display.
    let item: FDItem

    /// The index of the item in the page.
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
        case .copyright:
            // Some API endpoints miss the copyright disclaimer. Instead we hardcode a disclaimer at the bottom of each page, so this can
            // be ignored here instead.
            EmptyView()
        #if DEBUG
        case .unknown:
            Text("UNKNOWN value of FDItem decoded")
                .frame(maxWidth: .infinity)
                .background(.red)
        #endif
        default:
            EmptyView()
        }
    }
}

#Preview {
    DiscoveryItemView(item: .copyright(FDCopyright(lastUpdated: Date())), index: 0, hasHeader: false, destination: .constant(nil))
}
