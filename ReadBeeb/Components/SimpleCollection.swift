//
//  SimpleCollection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct SimpleCollection: View {
    let item: FDSimpleCollection

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

struct SimpleCollectionItem_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCollection(item: FDSimpleCollection(type: "SimpleCollection", items: []))
    }
}
