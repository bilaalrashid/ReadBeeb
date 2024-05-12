//
//  StoryPromoRow.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI
import BbcNews

struct StoryPromoRow: View {
    let story: FDStoryPromo

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @Binding var destination: FDLinkDestination?

    /// Returns the appropriate badge to be displayed in the row, if applicable.
    private var badgeForDisplay: FDBadge? {
        if let badge = self.story.badges?.first(where: { $0.type == "BREAKING" }) {
            return badge
        }

        return self.story.badges?.first { $0.type == "LIVE" }
    }

    var body: some View {
        HStack {
            ThumbnailImageView(image: self.story.image, badges: self.story.badges, prominent: false)
                .frame(width: 75 * 1.77777, height: 75)

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

                HStack {
                    if let topic = self.story.topic, let text = topic.text {
                        Button(action: {
                            self.destination = topic.link?.destinations.first
                        }) {
                            Text(text)
                                .font(.caption)
                                .foregroundColor(.accentColor)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()

                    if let badge = self.badgeForDisplay, let text = badge.text {
                        Text(text)
                            .font(.caption.weight(.heavy))
                            .foregroundColor(badge.brand == "SPORT" ? Constants.sportColor : .accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    } else if let lastUpdated = self.story.updated {
                        Text(lastUpdated.formattedTimestamp)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
            }
            .padding(.all, 4)
        }
    }
}

#Preview {
    List {
        StoryPromoRow(
            story: FDStoryPromo(
                style: "SMALL_HORIZONTAL_PROMO_CARD",
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                link: FDLink(destinations: []),
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                updated: 1715511413682,
                topic: FDTopic(text: "UK"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: "SPECIFIC_WIDTHS",
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
        StoryPromoRow(
            story: FDStoryPromo(
                style: "SMALL_HORIZONTAL_PROMO_CARD",
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                link: FDLink(destinations: []),
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                updated: 1715511413682,
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: "SPECIFIC_WIDTHS",
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
        StoryPromoRow(
            story: FDStoryPromo(
                style: "SMALL_HORIZONTAL_PROMO_CARD",
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                link: FDLink(destinations: []),
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                updated: 1715511413682,
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: "SPECIFIC_WIDTHS",
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                badges: [
                    FDBadge(type: "BREAKING", brand: "NEWS", text: "BREAKING")
                ],
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
        StoryPromoRow(
            story: FDStoryPromo(
                style: "SMALL_HORIZONTAL_PROMO_CARD",
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                link: FDLink(destinations: []),
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                updated: 1715511413682,
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: "SPECIFIC_WIDTHS",
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                badges: [
                    FDBadge(type: "LIVE", brand: "NEWS", text: "LIVE")
                ],
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
        StoryPromoRow(
            story: FDStoryPromo(
                style: "SMALL_HORIZONTAL_PROMO_CARD",
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                link: FDLink(destinations: []),
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                updated: 1715511413682,
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: "SPECIFIC_WIDTHS",
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                badges: [
                    FDBadge(type: "LIVE", brand: "SPORT", text: "LIVE")
                ],
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
    }
    .listStyle(.plain)
    .accentColor(Constants.primaryColor)
}
