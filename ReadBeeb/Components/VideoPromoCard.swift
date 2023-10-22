//
//  VideoPromoCard.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import Kingfisher

struct VideoPromoCard: View {
    let item: FDStoryPromo

    var body: some View {
        ZStack {
            KFImage(URL(string: self.item.image?.largestImageUrl))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                }
                .resizable()
                .scaledToFit()
                .frame(height: 450)

            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))

                    VStack {
                        Spacer()

                        if let badge = self.item.badges?.first(where: { $0.type == "VIDEO" }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                if let duration = badge.duration?.formattedTimeInterval {
                                    Text(duration)
                                        .font(.callout)
                                }
                                Spacer()
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                        }

                        if let text = self.item.text {
                            Text(text)
                                .font(.headline.weight(.heavy))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                                .frame(width: geometry.size.width, alignment: .leading)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VideoPromoCard(item: FDStoryPromo(type: "StoryPromo", style: "", languageCode: "", text: nil, link: FDLink(destinations: []), subtext: nil, updated: nil, topic: nil, image: nil, badges: nil, uasToken: nil))
}
