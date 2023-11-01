//
//  StoryPromoCollection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/11/2023.
//

import SwiftUI

struct StoryPromoCollection: View {
    let collection: FDCollection

    var body: some View {
        ForEach(Array(self.collection.items.enumerated()), id: \.offset) { index, storyPromo in
            if let destination = storyPromo.link.destinations.first {
                // Workaround to hide detail disclosure
                ZStack {
                    NavigationLink(destination: DestinationDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                    StoryPromoRow(story: storyPromo)
                }
            }
        }
    }
}
