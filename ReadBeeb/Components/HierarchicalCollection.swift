//
//  HierarchicalCollection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct HierarchicalCollection: View {
    let item: FDHierarchicalCollection

    var body: some View {
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { index, item in
            if let destination = item.link.destinations.first {
                // Workaround to hide detail disclosure
                ZStack {
                    NavigationLink(destination: DestinationDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                    StoryPromoRow(story: item)
                }
            }
        }
    }
}

struct HierarchicalCollectionItem_Previews: PreviewProvider {
    static var previews: some View {
        HierarchicalCollection(item: FDHierarchicalCollection(type: "HierarchicalCollection", items: []))
    }
}
