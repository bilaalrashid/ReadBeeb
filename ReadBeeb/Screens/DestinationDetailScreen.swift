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

    @StateObject private var viewModel: ViewModel

    init(destination: FDLinkDestination) {
        self.destination = destination
        // Initialising a StateObject like this is officially supported and endorsed by the SwiftUI team at Apple
        // See https://stackoverflow.com/a/62636048/10370537
        self._viewModel = StateObject(wrappedValue: ViewModel(destination: destination))
    }

    var body: some View {
        VStack(spacing: 0) {
            if self.viewModel.isApiUrl {
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
        .toolbarColorScheme(self.viewModel.isBBCSportUrl ? .light : .dark, for: .navigationBar)
        .toolbarBackground(self.viewModel.isBBCSportUrl ? Constants.sportColor : Constants.primaryColor, for: .navigationBar)
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
