//
//  Headline.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI

struct Headline: View {
    let headline: FDHeadline

    var body: some View {
        VStack(spacing: 16) {
            Text(self.headline.text)
                .font(.title2.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            if let byline = headline.byline {
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
                if let topic = headline.topic {
                    Text(topic.text)
                        .font(.callout)
                        .foregroundColor(.accentColor)
                }
                Text(self.headline.lastUpdated.formattedTimestamp)
                    .font(.callout)
                Text("\(self.headline.readTimeMinutes) min read")
                    .font(.callout)
                Spacer()
            }
        }
    }
}

struct Headline_Previews: PreviewProvider {
    static var previews: some View {
        Headline(headline:
                    FDHeadline(
                        type: "Headline",
                        text: "Headline",
                        lastUpdated: 0,
                        byline: FDHeadlineByline(name: "Chris Mason", purpose: "BBC News"),
                        topic: FDTopic(text: "Politics", link: nil),
                        languageCode: "en-GB",
                        readTimeMinutes: 2
                    )
        )
    }
}
