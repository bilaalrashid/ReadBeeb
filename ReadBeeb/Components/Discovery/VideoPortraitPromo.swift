//
//  VideoPortraitPromo.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import Kingfisher
import BbcNews

/// A view that displays a story promo for a portrait video story.
struct VideoPortraitPromo: View {
    /// The story promo to display.
    let storyPromo: FDStoryPromo

    var body: some View {
        ZStack {
            KFImage(self.storyPromo.image?.largestImageUrl)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                }
                .resizable()
                .modify {
                    if let url = self.storyPromo.image?.largestImageUrl(upTo: 1024) {
                        $0.lowDataModeSource(.network(url))
                    } else {
                        $0
                    }
                }
                .scaledToFit()
                .frame(height: 450)

            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))

                    VStack {
                        Spacer()

                        if let badge = self.storyPromo.badges?.first(where: { $0.type == .video }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                if let duration = badge.duration?.formattedMillisecondsDuration {
                                    Text(duration)
                                        .font(.callout)
                                }
                                Spacer()
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                        }

                        if let text = self.storyPromo.text {
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
