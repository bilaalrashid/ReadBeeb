//
//  ImageView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

struct ImageView: View {
    let image: FDImage
    var imageOnly = false

    var body: some View {
        VStack {
            ZStack {
                RemoteImage(
                    url: URL(string: self.image.largestImageUrl),
                    lowDataUrl: URL(string: self.image.largestImageUrl(upTo: 1024))
                )
                    .frame(
                        width: UIScreen.main.bounds.size.width,
                        height: UIScreen.main.bounds.size.width / (self.image.source.aspectRatio ?? 1.77777777)
                    )

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
            .frame(
                width: UIScreen.main.bounds.size.width,
                height: UIScreen.main.bounds.size.width / (self.image.source.aspectRatio ?? 1.77777777)
            )

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

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: FDImage(type: "Image", source: FDImageSource(url: "", sizingMethod: FDImageSizingMethod(type: "", widthToken: "", widths: []), aspectRatio: nil), metadata: nil))
    }
}
