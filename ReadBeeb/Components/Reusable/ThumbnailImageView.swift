//
//  ThumbnailImageView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a thumbnail image for a story promo.
struct ThumbnailImageView: View {
    /// The image to display.
    let image: FDImage?

    /// A list of badges to display over the thumbnail image.
    let badges: [FDBadge]?

    /// If the thumbnail is being displayed in a prominent story promo row.
    let prominent: Bool

    var body: some View {
        ZStack {
            if self.prominent {
                RemoteImage(
                    url: self.image?.largestImageUrl,
                    lowDataUrl: self.image?.largestImageUrl(upTo: 400)
                )
            } else {
                RemoteImage(
                    url: self.image?.largestImageUrl(upTo: 400),
                    lowDataUrl: self.image?.largestImageUrl(upTo: 200)
                )
            }

            if let badge = self.badges?.first(where: { [.video, .audio].contains($0.type) }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: badge.type == .audio ? "speaker.wave.1.fill" : "play.fill")
                                .resizable()
                                .scaledToFit()
                                .modify {
                                    if self.prominent {
                                        $0.frame(width: 22, height: 22)
                                    } else {
                                        $0.frame(width: 14, height: 14)
                                    }
                                }
                            if let duration = badge.duration?.formattedTimeInterval {
                                Text(duration)
                                    .modify {
                                        if self.prominent {
                                            $0.font(.body)
                                        } else {
                                            $0.font(.callout)
                                        }
                                    }
                            }
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(self.prominent ? 16 : 10)
                    }
                }
            }
        }
    }
}
