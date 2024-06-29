//
//  TextCarousel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/11/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a carousel of text paragraphs.
///
/// This is currently implemented as an unordered, bullet list.
struct TextCarousel: View {
    /// The carousel to display.
    let carousel: FDCarousel

    /// A destination that the text container can link to e.g. another story.
    @Binding var destination: FDLinkDestination?

    var body: some View {
        ForEach(Array(self.carousel.storyPromos.enumerated()), id: \.offset) { _, storyPromo in
            if let textContainer = self.textContainer(for: storyPromo) {
                TextContainer(
                    container: textContainer,
                    // `TextContainer` doesn't use this property much, we just need to define it as an UNORDERED type to get bullets
                    list: FDContentList(ordering: .unordered, listItems: []),
                    destination: self.$destination
                )
            }
        }
    }

    /// Converts a `FDStoryPromo` to a `FDTextContainer`.
    private func textContainer(for storyPromo: FDStoryPromo) -> FDTextContainer? {
        guard let text = storyPromo.text else { return nil }

        return FDTextContainer(
            containerType: .body,
            text: FDAttributedText(text: text, spans: [
                FDAttributedTextSpan(type: .link, startIndex: 0, length: text.count, attribute: nil, link: storyPromo.link)
            ])
        )
    }
}
