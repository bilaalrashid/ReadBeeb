//
//  MediaView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import SwiftUI
import OSLog

struct MediaView: View {

    let media: FDMedia

    @State private var shouldPlay = false
    @State private var networkResult = NetworkRequestStatus<MediaSelectorResult>.loading

    var body: some View {
        VStack {
            if self.shouldPlay {
                switch self.networkResult {
                case .error:
                    VStack {
                        Spacer()
                        Text("There was an error loading the video")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .background(Color(UIColor.systemGray6))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.77777)
                case .loading:
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .background(Color(UIColor.systemGray6))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.77777)
                case .success(let result):
                    // It is safe to access [0] on both properties, as their size is checked elsewhere
                    BBCIPlayerVideoPlayer(url: result.validMedia[0].validConnection[0].hrefSecure, shouldPlay: self.$shouldPlay)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.77777)
                }
            } else {
                ZStack {
                    ImageView(image: self.media.image, imageOnly: true)
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.shouldPlay = true
                                }) {
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
        .onAppear {
            Task {
                await self.fetchMediaSelectorItems()
            }
        }
    }

    private func fetchMediaSelectorItems() async {
        do {
            let result = try await BBCIPlayerAPINetworkController.fetchMediaConnections(for: self.media.source.id)
            if !result.validMedia.isEmpty {
                self.networkResult = .success(result)
            } else {
                self.networkResult = .error
                Logger.network.error("No valid media streams form BBC iPlayer API")
            }
        } catch let error {
            self.networkResult = .error
            Logger.network.error("Unable to fetch BBC iPlayer media options - \(error.localizedDescription)")
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
