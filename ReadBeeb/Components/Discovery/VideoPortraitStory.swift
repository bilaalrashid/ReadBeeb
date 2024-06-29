//
//  VideoPortraitStory.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import OSLog
import BbcNews

/// A view that displays a story that consists of a portrait video.
struct VideoPortraitStory: View {
    /// The story to display.
    let storyPromo: FDStoryPromo

    /// Has the user requested that the media item should be played.
    @State private var shouldPlay = false

    /// A list of media selectors that can be used to play the media item from.
    @State private var result: MediaSelectorResult?

    /// The state of the network request fetching the media selectors.
    @State private var networkResult = NetworkRequestStatus.notStarted

    var body: some View {
        ZStack {
            Button(action: {
                self.shouldPlay = true
            }) {
                VideoPortraitPromo(storyPromo: self.storyPromo)
            }
            .buttonStyle(.plain)

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
                case .loading, .notStarted:
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .background(Color(UIColor.systemGray6))
                case .success:
                    // It is safe to access [0] on both properties, as their size is checked elsewhere
                    if let result = self.result {
                        BBCIPlayerVideoPlayer(url: result.validMedia[0].validConnection[0].hrefSecure, shouldPlay: self.$shouldPlay)
                    }
                }
            }
        }
        .padding(.bottom)
        .onAppear {
            Task {
                await self.fetchDetailView()
            }
        }
    }

    /// Performs a network request to fetch the media item for the story promo.
    private func fetchDetailView() async {
        do {
            self.networkResult = .loading
            if let url = self.storyPromo.link.destinations.first?.url {
                let detail = try await BbcNews().fetch(url: url)
                if case .videoPortraitStory(let videoPortraitStory) = detail.data.items.first {
                    await self.fetchMediaSelectorItems(media: videoPortraitStory.media)
                }
            } else {
                self.networkResult = .error
                Logger.network.error("No URL to fetch details for")
            }
        } catch let error {
            self.networkResult = .error
            Logger.network.error("Unable to fetch BBC iPlayer media options - \(error.localizedDescription)")
        }
    }

    /// Performs a network request to fetch a list of media selectors for the media item.
    private func fetchMediaSelectorItems(media: FDMedia) async {
        do {
            self.networkResult = .loading
            let result = try await BBCIPlayerAPINetworkController().fetchMediaConnections(for: media.source.id)
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
