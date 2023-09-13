//
//  MediaView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import SwiftUI

struct MediaView: View {
    let media: FDMedia

    var body: some View {
        ZStack {
            ImageView(image: self.media.image, imageOnly: true)
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .padding(24)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    MediaView(media: FDMedia(
        type: "Media",
        source: FDMediaSource(type: "VIDEO", id: "", duration: 100, aspectRatio: 1.77, isLive: false, canAutoPlay: true, episodePid: ""),
        image: FDImage(type: "Image", source: FDImageSource(url: "", sizingMethod: FDImageSizingMethod(type: "", widthToken: "", widths: []), aspectRatio: nil), metadata: nil),
        metadata: FDMediaMetadata(title: "Title", summary: "Subtitle", caption: "Caption", timestamp: 0, associatedContentUrl: "https://www.bbc.co.uk/news/world-asia-66783384", allowAdvertising: true))
    )
}
