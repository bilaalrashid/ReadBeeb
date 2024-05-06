//
//  Headline.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI
import BbcNews

struct Headline: View {
    let headline: FDHeadline

    @State private var isLinkActive = false

    var body: some View {
        VStack(spacing: 16) {
            Text(self.headline.text)
                .font(.title2.weight(.semibold))
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
                        self.isLinkActive = true
                    }) {
                        Text(text)
                            .font(.callout)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }

                if let published = headline.published {
                    Text(published.formattedTimestamp)
                        .font(.callout)
                }

                Text("\(self.headline.readTimeMinutes) min read")
                    .font(.callout)

                Spacer()
            }
        }
        .navigationDestination(isPresented: self.$isLinkActive) {
            if let destination = self.headline.topic?.link?.destinations.first {
                DestinationDetailScreen(destination: destination)
            }
        }
    }
}

struct Headline_Previews: PreviewProvider {
    static var previews: some View {
        Headline(
            headline: FDHeadline(
                text: "Headline",
                lastUpdated: 0,
                firstPublished: 0,
                lastPublished: 0,
                byline: FDHeadlineByline(name: "Chris Mason", purpose: "BBC News"),
                topic: FDTopic(text: "Politics", title: nil, link: nil),
                languageCode: "en-GB",
                readTimeMinutes: 2
            )
        )
    }
}
