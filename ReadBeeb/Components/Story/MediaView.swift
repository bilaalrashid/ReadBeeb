//
//  MediaView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 13/09/2023.
//

import SwiftUI
import BbcNews
import OSLog

struct MediaView: View {
    let media: FDMedia

    @State private var shouldPlay = false
    @State private var result: MediaSelectorResult?
    @State private var networkResult = NetworkRequestStatus.notStarted

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
                    .frame(width: UIScreen.main.bounds.width, aspectRatio: self.media.source.aspectRatio)
                case .loading, .notStarted:
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .background(Color(UIColor.systemGray6))
                    .frame(width: UIScreen.main.bounds.width, aspectRatio: self.media.source.aspectRatio)
                case .success:
                    // It is safe to access [0] on both properties, as their size is checked elsewhere
                    if let result = self.result {
                        BBCIPlayerVideoPlayer(url: result.validMedia[0].validConnection[0].hrefSecure, shouldPlay: self.$shouldPlay)
                            .frame(width: UIScreen.main.bounds.width, aspectRatio: self.media.source.aspectRatio)
                    }
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
            self.networkResult = .loading
            let result = try await BBCIPlayerAPINetworkController().fetchMediaConnections(for: self.media.source.id)
            if !result.validMedia.isEmpty {
                self.result = result
                self.networkResult = .success
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
