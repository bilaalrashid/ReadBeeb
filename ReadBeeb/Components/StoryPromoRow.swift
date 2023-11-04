//
//  StoryPromoRow.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI

struct StoryPromoRow: View {

    let story: FDStoryPromo

    @State private var topicDestination: FDLinkDestination?

    var body: some View {
        HStack {
            if let image = self.story.image {
                ThumbnailImageView(image: image, badges: self.story.badges, prominent: false)
                    .frame(width: 75 * 1.77777, height: 75)
            }

            VStack {
                if let title = self.story.text {
                    Text(title)
                        .font(.headline)
                        .lineLimit(3)
                        .minimumScaleFactor(0.95)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 1)

                HStack(alignment: .center) {
                    if let topic = self.story.topic, let text = topic.text {
                        Button(action: {
                            self.topicDestination = topic.link?.destinations.first
                        }) {
                            Text(text)
                                .font(.caption)
                                .foregroundColor(.accentColor)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                    }

                    if let badges = self.story.badges {
                        ForEach(Array(badges.enumerated()), id: \.offset) { _, badge in
                            Text(badge.text ?? "")
                                .font(.caption.weight(.heavy))
                                .foregroundColor(.accentColor)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }

                    if let lastUpdated = self.story.updated {
                        Text(lastUpdated.formattedTimestamp)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .padding(.all, 4)
        }
        .navigationDestination(item: self.$topicDestination) { destination in
            DestinationDetailScreen(destination: destination)
        }
    }

}

struct NewsStoryRow_Previews: PreviewProvider {
    static var previews: some View {
        StoryPromoRow(story:
                        FDStoryPromo(type: "StoryPromo", style: "SMALL_HORIZONTAL_PROMO_CARD", languageCode: "en-gb", text: nil, link: FDLink(destinations: []), subtext: nil, updated: nil, topic: nil, image: nil, badges: nil, uasToken: nil)
        )
    }
}
