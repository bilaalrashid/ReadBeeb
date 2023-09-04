//
//  NewsStoryRow.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI

struct NewsStoryRow: View {

    let story: BBCNewsAPIFederatedDiscoveryItemItem

    var body: some View {
        HStack {
            if let url = getImageUrl() {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.1)
                }
                .frame(width: 75 * 1.77777, height: 75)
            }
            VStack {
                if let title = self.story.text {
                    Text(title)
                        .font(.headline)
                        .lineLimit(3)
                        .minimumScaleFactor(0.95)
                        .truncationMode(.tail)
                }
                Spacer(minLength: 1)
                HStack {
                    if let topic = self.story.topic {
                        Text(topic.text)
                            .font(.caption)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    Spacer()
                    if let lastUpdated = self.story.updated {
                        Text(self.formatTimestamp(timestamp: lastUpdated))
                            .font(.caption)
                    }
                }
            }
            .padding(.all, 4)
        }
    }

    private func getImageUrl() -> String? {
        if let image = self.story.image {
            if image.source.sizingMethod.type == .specificWidths {
                // This attempts to load the largest image possible, this may not be favourable in production
                if let maxSize = image.source.sizingMethod.widths.last {
                    let formattedUrl = image.source.url.replacingOccurrences(of: image.source.sizingMethod.widthToken.rawValue, with: String(maxSize))
                    return formattedUrl
                }
            } else {
                return image.source.url
            }
        }

        return nil
    }

    private func formatTimestamp(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp) / 1000)
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        if date < lastWeek {
            return date.formatted(date: .abbreviated, time: .omitted)
        } else {
            return date.formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
        }
    }

}

struct NewsStoryRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsStoryRow(story:
                        BBCNewsAPIFederatedDiscoveryItemItem(
                            type: nil,
                            style: nil,
                            languageCode: nil,
                            text: nil,
                            link: BBCNewsAPIFederatedDiscoveryItemLink(trackers: [], destinations: []),
                            subtext: nil,
                            updated: nil,
                            topic: nil,
                            image: nil,
                            badges: nil,
                            uasToken: nil,
                            title: nil
                        )
        )
    }
}
