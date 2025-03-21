//
//  CollectionHeader.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a header for a story promo collection.
struct CollectionHeader: View {
    /// The collect header to display.
    let item: FDCollectionHeader

    var body: some View {
        HStack {
            if let destination = self.item.link?.destinations.first {
                NavigationLink(self.item.text, destination: DestinationDetailScreen(destination: destination))
            } else {
                Text(self.item.text)
            }
        }
        .font(.title3.bold())
    }
}

struct CollectionHeaderItem_Previews: PreviewProvider {
    static var previews: some View {
        CollectionHeader(item: FDCollectionHeader(text: "News from London", link: FDLink(destinations: [], trackers: [])))
    }
}
