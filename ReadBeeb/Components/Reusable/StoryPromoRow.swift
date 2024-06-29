//
//  StoryPromoRow.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a regular horizontal row for story promo.
struct StoryPromoRow: View {
    /// The story promo to display.
    let story: FDStoryPromo

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @Binding var destination: FDLinkDestination?

    /// Returns the appropriate badge to be displayed in the row, if applicable.
    private var badgeForDisplay: FDBadge? {
        if let badge = self.story.badges?.first(where: { $0.type == .breaking }) {
            return badge
        }

        return self.story.badges?.first { $0.type == .live }
    }

    /// The aspect ratio of the image.
    private var imageAspectRatio: Double {
        return self.story.image?.source.aspectRatio ?? Constants.defaultImageAspectRatio
    }

    var body: some View {
        HStack {
            ThumbnailImageView(image: self.story.image, badges: self.story.badges, prominent: false)
                .frame(width: 134, aspectRatio: self.imageAspectRatio)

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
                    // Display order badge if provided, otherwise display the topic
                    if let text = self.story.badges?.first(where: { $0.type == .ordered })?.text ?? self.story.topic?.text {
                        Button(action: {
                            self.destination = self.story.topic?.link?.destinations.first
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
                            .foregroundColor(badge.brand == .sport ? Constants.sportColor : .accentColor)
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
        .contextMenu {
            if let shareUrl = self.story.link.destinations.first?.shareUrl {
                ShareLink(item: shareUrl)
            }

            #if DEBUG
            if let apiUrl = self.story.link.destinations.first?.url {
                Button(action: {
                    UIPasteboard.general.string = apiUrl.absoluteString
                }) {
                    Label("Copy API URL", systemImage: "link")
                }
            }
            #endif
        }
    }
}

#Preview {
    List {
        StoryPromoRow(
            story: FDStoryPromo(
                style: .smallHorizontalPromoCard,
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                link: FDLink(destinations: [], trackers: []),
                updated: Date(),
                topic: FDTopic(text: "UK"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: .specificWidths,
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
                style: .smallHorizontalPromoCard,
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                link: FDLink(destinations: [], trackers: []),
                updated: Date(),
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: .specificWidths,
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
                style: .smallHorizontalPromoCard,
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                link: FDLink(destinations: [], trackers: []),
                updated: Date(),
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: .specificWidths,
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                badges: [
                    FDBadge(type: .breaking, brand: .news, text: "BREAKING")
                ],
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
        StoryPromoRow(
            story: FDStoryPromo(
                style: .smallHorizontalPromoCard,
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                link: FDLink(destinations: [], trackers: []),
                updated: Date(),
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: .specificWidths,
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                badges: [
                    FDBadge(type: .live, brand: .news, text: "LIVE")
                ],
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
        StoryPromoRow(
            story: FDStoryPromo(
                style: .smallHorizontalPromoCard,
                languageCode: "en-gb",
                text: "Why you probably missed the Northern Lights on Saturday",
                subtext: "The Northern Lights waned early on Saturday night, but picked up again much later.",
                link: FDLink(destinations: [], trackers: []),
                updated: Date(),
                topic: FDTopic(text: "Entertainment & Arts"),
                image: FDImage(
                    source: FDImageSource(
                        url: "https://ichef.bbci.co.uk/moira/img/android/v3/{width}/cpsprodpb/3dfc/live/fd4d6280-102b-11ef-b521-293a36493444.jpg",
                        sizingMethod: FDImageSizingMethod(
                            type: .specificWidths,
                            widthToken: "{width}",
                            widths: [128, 1024, 2560]
                        ),
                        aspectRatio: 1.7772511848341233
                    ),
                    metadata: nil
                ),
                badges: [
                    FDBadge(type: .live, brand: .sport, text: "LIVE")
                ],
                uasToken: "urn:bbc:optimo:asset:cglv53402mko"
            ),
            destination: .constant(nil)
        )
    }
    .listStyle(.plain)
    .accentColor(Constants.primaryColor)
}
