//
//  ImageView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a image and related caption.
struct ImageView: View {
    /// The image to display.
    let image: FDImage

    /// If the caption should be hidden.
    var imageOnly = false

    /// The aspect ratio of the image.
    private var aspectRatio: Double {
        return self.image.source.aspectRatio ?? Constants.defaultImageAspectRatio
    }

    var body: some View {
        VStack {
            ZStack {
                RemoteImage(
                    url: self.image.largestImageUrl,
                    lowDataUrl: self.image.largestImageUrl(upTo: 1024)
                )
                .frame(width: UIScreen.main.bounds.size.width, aspectRatio: self.aspectRatio)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if let copyrightText = self.image.metadata?.copyrightText, !self.imageOnly {
                            Text(copyrightText)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(6)
                                .background(.black.opacity(0.7))
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, aspectRatio: self.aspectRatio)

            if let caption = self.image.metadata?.caption, !self.imageOnly {
                Text(caption)
                    .font(.caption)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
