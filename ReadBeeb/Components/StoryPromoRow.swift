//
//  StoryPromoRow.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI

struct StoryPromoRow: View {

    let story: FDStoryPromo

    var body: some View {
        HStack {
            if let image = self.story.image, let url = image.largestImageUrl(upTo: 400) {
                ZStack {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
                    
                    if let badge = self.story.badges?.first, badge.type == "VIDEO" {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                            VStack {
                                Spacer()
                                HStack {
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                    if let duration = badge.duration?.formattedTimeInterval {
                                        Text(duration)
                                            .font(.callout)
                                    }
                                    Spacer()
                                }
                                .foregroundStyle(.white)
                                .padding(10)
                            }
                        }

                    }
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 1)
                HStack(alignment: .center) {
                    if let topic = self.story.topic?.text {
                        Text(topic)
                            .font(.caption)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if let badges = self.story.badges {
                        ForEach(Array(badges.enumerated()), id: \.offset) { index, badge in
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
    }

}

struct NewsStoryRow_Previews: PreviewProvider {
    static var previews: some View {
        StoryPromoRow(story:
                        FDStoryPromo(type: "StoryPromo", style: "SMALL_HORIZONTAL_PROMO_CARD", languageCode: "en-gb", text: nil, link: FDLink(destinations: []), subtext: nil, updated: nil, topic: nil, image: nil, badges: nil, uasToken: nil)
        )
    }
}
