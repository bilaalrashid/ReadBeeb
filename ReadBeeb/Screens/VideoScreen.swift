//
//  VideoScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import BbcNews
import OSLog

/// The screen that displays story promos for video-only stories.
struct VideoScreen: View {
    /// The sections from the API's main feed to display in the screen.
    private let sectionsToInclude = ["Today's videos", "The video playlist"]

    /// The global view model representing the system.
    @EnvironmentObject var viewModel: GlobalViewModel

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @State private var destination: FDLinkDestination?

    var body: some View {
        VStack {
            if let data = self.viewModel.data {
                DiscoveryView(data: data, sectionsToInclude: self.sectionsToInclude, shouldHideSeparators: true) {
                    AnyView(
                        ForEach(Array(self.viewModel.videoPromos.enumerated()), id: \.offset) { _, storyPromo in
                            if let destination = storyPromo.link.destinations.first {
                                PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                                    StoryPromoRow(story: storyPromo, destination: $destination)
                                }
                            }
                        }
                    )
                }
            }
        }
        .navigationDestination(item: self.$destination) { destination in
            DestinationDetailScreen(destination: destination)
        }
        .navigationTitle("Video")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
        .refreshable {
            await self.viewModel.fetchData()
            // We don't care about the network state when fetching all videos - some will be preloaded and that is enough
            await self.viewModel.fetchAllVideos()
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists()
                // We don't care about the network state when fetching all videos - some will be preloaded and that is enough
                await self.viewModel.fetchAllVideosIfNotExists()
            }
        }
    }
}
