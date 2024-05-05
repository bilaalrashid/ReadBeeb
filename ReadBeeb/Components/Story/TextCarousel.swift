//
//  TextCarousel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/11/2023.
//

import SwiftUI
import BbcNews

struct TextCarousel: View {
    let carousel: FDCarousel

    var body: some View {
        ForEach(Array(self.carousel.items.enumerated()), id: \.offset) { _, storyPromo in
            if let textContainer = self.textContainer(for: storyPromo) {
                TextContainer(
                    container: textContainer,
                    // `TextContainer` doesn't use this property much, we just need to define it as an UNORDERED type to get bullets
                    list: FDContentList(type: "", ordering: "UNORDERED", listItems: [])
                )
            }
        }
    }

    private func textContainer(for storyPromo: FDStoryPromo) -> FDTextContainer? {
        guard let text = storyPromo.text else { return nil }

        return FDTextContainer(
            type: "textContainer",
            containerType: "body",
            text: FDTextContainerText(text: text, spans: [
                FDTextContainerSpan(type: "link", startIndex: 0, length: text.count, attribute: nil, link: storyPromo.link)
            ])
        )
    }
}
