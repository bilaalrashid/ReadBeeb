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
        case .billboard(let item):
            Billboard(item: item)
        case .hierarchicalCollection(let item):
            HierarchicalCollection(item: item)
        case .collectionHeader(let item):
            CollectionHeader(item: item)
        case .simpleCollection(let item):
            SimpleCollection(item: item)
        case .simplePromoGrid(let item):
            SimplePromoGrid(item: item)
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
