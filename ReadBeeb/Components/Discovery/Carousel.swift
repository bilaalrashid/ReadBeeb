//
//  Carousel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a carousel of story promos.
struct Carousel: View {
    /// The carousel of story promos to display.
    let item: FDCarousel

    var body: some View {
        ScrollView(.horizontal) {
            // Don't use LazyHStack, the layout doesn't render properly if lazy loaded
            HStack(spacing: 16) {
                ForEach(Array(self.item.storyPromos.enumerated()), id: \.offset) { _, storyPromo in
                    VideoPortraitStory(storyPromo: storyPromo)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.never)
    }
}
