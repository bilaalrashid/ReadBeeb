//
//  ProminentStoryPromoRow.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/11/2023.
//

import SwiftUI

struct ProminentStoryPromoRow: View {
    let story: FDStoryPromo

    @State private var topicDestination: FDLinkDestination?

    var body: some View {
        VStack(spacing: 12) {
            ThumbnailImageView(image: self.story.image, badges: self.story.badges, prominent: true)
                .frame(width: UIScreen.main.bounds.width - 36, height: (UIScreen.main.bounds.width - 36) / 1.7777)

            VStack(spacing: 12) {
                if let title = self.story.text {
                    Text(title)
                        .font(.title3.bold())
                        .lineLimit(3)
                        .minimumScaleFactor(0.95)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }

                if let subtext = self.story.subtext {
                    Text(subtext)
                        .font(.callout)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }

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
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .navigationDestination(item: self.$topicDestination) { destination in
            DestinationDetailScreen(destination: destination)
        }
    }
}
