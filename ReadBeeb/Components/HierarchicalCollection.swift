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
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { _, storyPromo in
            if let destination = storyPromo.link.destinations.first {
                PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                    StoryPromoRow(story: storyPromo)
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
