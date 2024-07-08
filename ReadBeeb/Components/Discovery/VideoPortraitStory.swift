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
                    if let result = self.result, let url = result.validMedia[0].validConnection[0].hrefSecure {
                        RemoteVideoPlayer(url: url, shouldPlay: self.$shouldPlay)
                    }
                }
            }
        }
        .padding(.bottom)
        .onAppear {
            Task {
                if let media = await self.fetchDetailView() {
                    await self.fetchMediaSelectorItems(media: media)
                }
            }
        }
    }

    /// Performs a network request to fetch the media item for the story promo.
    ///
    /// - Returns: The media item linked to by the story promo.
    private func fetchDetailView() async -> FDMedia? {
        guard let url = self.storyPromo.link.destinations.first?.url else {
            self.networkResult = .error
            Logger.network.error("No URL to fetch details for")

            return nil
        }

        do {
            let detail = try await BbcNews().fetch(url: url)

            if case .videoPortraitStory(let videoPortraitStory) = detail.data.items.first {
                self.networkResult = .success
                return videoPortraitStory.media
            }

            self.networkResult = .error
            Logger.network.error("No video portrait story found in API result")
        } catch let error {
            self.networkResult = .error
            Logger.network.error("Unable to fetch BBC iPlayer media options - \(error.localizedDescription)")
        }

        return nil
    }

    /// Performs a network request to fetch a list of media selectors for the media item.
    private func fetchMediaSelectorItems(media: FDMedia) async {
        self.networkResult = .loading

        do {
            let result = try await BbcMedia().fetchMediaConnections(for: media.source.id)

            guard result.validMedia.isEmpty else {
                self.networkResult = .error
                Logger.network.error("No valid media streams form BBC iPlayer API")

                return
            }

            self.result = result
            self.networkResult = .success
        } catch let error {
            self.networkResult = .error
            Logger.network.error("Unable to fetch BBC iPlayer media options - \(error.localizedDescription)")
        }
    }
}
