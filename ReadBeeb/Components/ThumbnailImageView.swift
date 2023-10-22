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

    var body: some View {
        if let url = self.image.largestImageUrl(upTo: 400) {
            ZStack {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.1)
                }

                if let badge = self.badges?.first, badge.type == "VIDEO" {
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
    }
}

#Preview {
    ThumbnailImageView(image: FDImage(type: "Image", source: FDImageSource(url: "", sizingMethod: FDImageSizingMethod(type: "", widthToken: "", widths: []), aspectRatio: nil), metadata: nil), badges: [])
}
