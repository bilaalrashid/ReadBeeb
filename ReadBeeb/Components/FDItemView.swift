//
//  FDItemView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI

struct FDItemView: View {
    let item: FDItem

    var body: some View {
        switch item {
        case .hierarchicalCollection(let item):
            HierarchicalCollection(item: item)
        case .collectionHeader(let item):
            CollectionHeader(item: item)
        case .simpleCollection(let item):
            SimpleCollection(item: item)
        default:
            EmptyView()
        }
    }
}

struct FFDItemView_Previews: PreviewProvider {
    static var previews: some View {
        FDItemView(item:
                .collectionHeader(FDCollectionHeader(type: "CollectionHeader", text: "News from London", link: FDLink(destinations: [])))
        )
    }
}
