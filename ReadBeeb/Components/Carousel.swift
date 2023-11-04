//
//  Carousel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI

struct Carousel: View {

    let item: FDCarousel

    var body: some View {
        ScrollView(.horizontal) {
            // Don't use LazyHStack, the layout doesn't render properly if lazy loaded
            HStack(spacing: 16) {
                ForEach(Array(self.item.items.enumerated()), id: \.offset) { _, storyPromo in
                    VideoPortraitStory(storyPromo: storyPromo)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.never)
    }

}

#Preview {
    Carousel(item: FDCarousel(type: "Carousel", items: [], aspectRatio: 1.3, presentation: FDPresentation(type: "", title: nil, canShare: nil), hasPageIndicator: false))
}
