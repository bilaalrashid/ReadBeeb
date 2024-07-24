//
//  Headline.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a headline for a story.
///
/// A `Headline` contains the story title, topic, published date and estimated read time. Older versions of the BBC News API also include
/// the byline in the headline. This is now stored in the `Byline` sibling view.
struct Headline: View {
    let headline: FDHeadline

    /// A destination that the headline can link to e.g. a topic discovery page.
    @Binding var destination: FDLinkDestination?

    var body: some View {
        VStack(spacing: 16) {
            Text(self.headline.text)
                .font(.system(size: 24, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)

            if let byline = self.headline.byline {
                VStack(spacing: 4) {
                    Text(byline.name)
                        .font(.callout.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text(byline.purpose)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }

            HStack {
                if let text = self.headline.topic?.text {
                    Button(action: {
                        self.destination = self.headline.topic?.link?.destinations.first
                    }) {
                        Text(text)
                            .font(.callout)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }

                if let published = headline.published {
                    Text(published.formattedString)
                        .font(.callout)
                }

                if let readTimeMinutes = headline.readTimeMinutes {
                    Text("\(readTimeMinutes) min read")
                        .font(.callout)
                }

                Spacer()
            }
        }
    }
}

struct Headline_Previews: PreviewProvider {
    static var previews: some View {
        Headline(
            headline: FDHeadline(
                text: "Headline",
                lastUpdated: Date(),
                firstPublished: Date(),
                lastPublished: Date(),
                byline: FDHeadlineByline(name: "Chris Mason", purpose: "BBC News"),
                topic: FDTopic(text: "Politics", title: nil, link: nil),
                languageCode: "en-GB",
                readTimeMinutes: 2
            ),
            destination: .constant(nil)
        )
    }
}
