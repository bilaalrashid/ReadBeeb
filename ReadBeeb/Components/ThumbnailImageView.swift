//
//  ThumbnailImageView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI

struct ThumbnailImageView: View {
    let image: FDImage
    let badges: [FDBadge]?
    let prominent: Bool

    var body: some View {
        ZStack {
            if self.prominent {
                RemoteImage(
                    url: URL(string: self.image.largestImageUrl),
                    lowDataUrl: URL(string: self.image.largestImageUrl(upTo: 400))
                )
            } else {
                RemoteImage(
                    url: URL(string: self.image.largestImageUrl(upTo: 400)),
                    lowDataUrl: URL(string: self.image.largestImageUrl(upTo: 200))
                )
            }

            if let badge = self.badges?.first(where: { $0.type == "VIDEO" }) {
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

#Preview {
    ThumbnailImageView(image: FDImage(type: "Image", source: FDImageSource(url: "", sizingMethod: FDImageSizingMethod(type: "", widthToken: "", widths: []), aspectRatio: nil), metadata: nil), badges: [], prominent: false)
}
