//
//  StoryPromoCollection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/11/2023.
//

import SwiftUI
import BbcNews

struct StoryPromoCollection: View {
    let collection: FDCollection
    let collectionIndex: Int
    /// If the collection has a header displayed above it.
    let hasHeader: Bool

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @Binding var destination: FDLinkDestination?

    var body: some View {
        ForEach(Array(self.collection.storyPromos.enumerated()), id: \.offset) { index, storyPromo in
            if let destination = storyPromo.link.destinations.first {
                PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                    if self.collectionIndex == 0 && index == 0 {
                        ProminentStoryPromoRow(story: storyPromo, hasHeader: self.hasHeader, destination: self.$destination)
                    } else {
                        StoryPromoRow(story: storyPromo, destination: self.$destination)
                    }
                }
            }
        }
    }
}
