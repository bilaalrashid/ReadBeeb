//
//  ImageView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

struct ImageView: View {
    let image: FDImage

    var body: some View {
        if let url = self.image.largestImageUrl {
            VStack {
                ZStack {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
                    .frame(
                        width: UIScreen.main.bounds.size.width,
                        height: UIScreen.main.bounds.size.width / (self.image.source.aspectRatio ?? 1.77777777)
                    )
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if let copyrightText = self.image.metadata?.copyrightText {
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
                if let caption = self.image.metadata?.caption {
                    Text(caption)
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: FDImage(type: "Image", source: FDImageSource(url: "", sizingMethod: FDImageSizingMethod(type: "", widthToken: "", widths: []), aspectRatio: nil), metadata: nil))
    }
}
