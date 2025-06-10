//
//  DestinationDetailScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/09/2023.
//

import SwiftUI
import BbcNews
import OSLog

/// The detail screen for a given destination.
struct DestinationDetailScreen: View {
    /// The view model representing the screen.
    @StateObject private var viewModel: ViewModel

    /// Creates a new detail screen for a destination.
    ///
    /// - Parameter destination: The destination to display in the screen.
    init(destination: FDLinkDestination) {
        // Initialising a StateObject like this is officially supported and endorsed by the SwiftUI team at Apple. See:
        // https://stackoverflow.com/a/62636048/10370537
        self._viewModel = StateObject(wrappedValue: ViewModel(destination: destination))
    }

    var body: some View {
        VStack(spacing: 0) {
            if self.viewModel.destination.presentation.type == .web {
                StoryWebView(url: self.viewModel.destination.url) {
                    // Assign any non-empty value to prevent the empty data overlay being displayed
                    self.viewModel.mockSuccessfulApiRequest()
                }
            } else {
                if let data = self.viewModel.data {
                    switch self.viewModel.destinationType ?? "" {
                    case "index", "topic":
                        DiscoveryView(data: data)
                    case "asset":
                        StoryView(data: data)
                    case "verticalvideo":
                        EmptyView()
                    default:
                        StoryView(data: data)
                    }
                }
            }
        }
        .navigationTitle(self.viewModel.destination.presentation.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let shareUrl = self.viewModel.destination.shareUrl {
                    ShareLink(item: shareUrl) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
        .refreshable {
            await self.viewModel.fetchData()
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists()
            }
        }
    }
}

struct NewsStoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationDetailScreen(
            destination: FDLinkDestination(
                sourceFormat: .abl,
                // swiftlint:disable:next force_unwrapping
                url: URL(string: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset")!,
                id: "/news/world-europe-66631182",
                presentation: FDPresentation(type: .singleRenderer, title: nil, canShare: true)
            )
        )
    }
}
