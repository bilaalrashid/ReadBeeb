//
//  TopicDetailView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI
import OSLog

struct TopicDetailView: View {

    let destination: FDLinkDestination

    @State private var data: FDResult? = nil
    @State private var networkRequest = NetworkRequestStatus.notStarted

    var body: some View {
        List {
            if let data = self.data {
                ForEach(Array(data.data.structuredItems.enumerated()), id: \.offset) { index, item in
                    if let header = item.header {
                        DiscoveryView(item: header)
                    }

                    DiscoveryView(item: item.body)
                }
            }
        }
        .listStyle(.plain)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
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
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.networkRequest, isEmpty: self.data?.data.structuredItems.isEmpty ?? true))
        .refreshable {
            await self.fetchData()
        }
        .onAppear {
            Task {
                await self.fetchData()
            }
        }
    }

    private func fetchData() async {
        do {
            self.networkRequest = .loading
            let result = try await BBCNewsAPINetworkController.fetchFDUrl(url: self.destination.url)
            self.data = result
            self.networkRequest = .success
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to topic page \(self.destination.url) - \(error.localizedDescription)")
        }
    }

}

#Preview {
    TopicDetailView(destination:
                        FDLinkDestination(
                            sourceFormat: "ABL",
                            url: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset",
                            id: "/news/world-europe-66631182",
                            presentation: FDPresentation(type: "", title: nil, canShare: true)
                        )
    )
}
