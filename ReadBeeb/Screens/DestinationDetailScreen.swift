//
//  DestinationDetailScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/09/2023.
//

import SwiftUI
import OSLog

struct DestinationDetailScreen: View {

    let destination: FDLinkDestination

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if self.viewModel.isApiUrl(url: self.destination.url) {
                if let data = self.viewModel.data {
                    switch URL(string: self.destination.url)?.valueOf("type") ?? "" {
                    case "index", "topic":
                        DiscoveryView(data: data, sectionsToInclude: nil, sectionsToExclude: nil)
                    case "asset":
                        StoryView(data: data)
                    case "verticalvideo":
                        EmptyView()
                    default:
                        StoryView(data: data)
                    }
                }
            } else {
                if let url = URL(string: self.destination.url) {
                    StoryWebView(url: url) {
                        // Assign any non-empty value to prevent the empty data overlay being displayed
                        self.viewModel.mockSuccessfulApiRequest()
                    }
                }
            }
        }
        .navigationTitle(self.destination.presentation.title ?? "")
        .toolbarColorScheme(self.viewModel.isBBCSportUrl(url: self.destination.url) ? .light : .dark, for: .navigationBar)
        .toolbarBackground(self.viewModel.isBBCSportUrl(url: self.destination.url) ? Constants.sportColor : Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let shareUrl = self.destination.shareUrl {
                    ShareLink(item: shareUrl) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
        .refreshable {
            await self.viewModel.fetchData(destination: self.destination)
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists(destination: self.destination)
            }
        }
    }

}

struct NewsStoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationDetailScreen(destination:
                                FDLinkDestination(
                                    sourceFormat: "ABL",
                                    url: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset",
                                    id: "/news/world-europe-66631182",
                                    presentation: FDPresentation(type: "", title: nil, canShare: true)
                                )
        )
    }
}
