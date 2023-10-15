//
//  StoryDetailView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/09/2023.
//

import SwiftUI
import OSLog

struct StoryDetailView: View {

    let destination: FDLinkDestination

    @State private var data: FDResult? = nil
    @State private var networkRequest = NetworkRequestStatus<Void>.notStarted

    var body: some View {
        VStack(spacing: 0) {
            if BBCNewsAPINetworkController.isAPIUrl(url: self.destination.url) {
                if let data = self.data {
                    StoryView(data: data)
                }
            } else {
                if let url = URL(string: self.destination.url) {
                    StoryWebView(url: url)
                }
            }
        }
        .toolbarColorScheme(self.isBBCSportUrl(url: self.destination.url) ? .light : .dark, for: .navigationBar)
        .toolbarBackground(self.isBBCSportUrl(url: self.destination.url) ? Constants.sportColor : Constants.primaryColor, for: .navigationBar)
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
        .overlay(Group {
            switch self.networkRequest {
            case .loading, .notStarted:
                if self.data == nil {
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
            case .error:
                Text("Unable to load data. Please try again later and contact support if the problem persists.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            case .success(_):
                EmptyView()
            }
        })
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
            if BBCNewsAPINetworkController.isAPIUrl(url: self.destination.url) {
                self.networkRequest = .loading
                let result = try await BBCNewsAPINetworkController.fetchFDUrl(url: self.destination.url)
                self.data = result
                self.networkRequest = .success(())
            }
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch news article \(self.destination.url) - \(error.localizedDescription)")
        }
    }

    private func isBBCSportUrl(url: String) -> Bool {
        return url.contains("https://www.bbc.co.uk/sport/")
    }

}

struct NewsStoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(destination:
                                FDLinkDestination(
                                    sourceFormat: "ABL",
                                    url: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset",
                                    id: "/news/world-europe-66631182",
                                    presentation: FDPresentation(type: "", title: nil, canShare: true)
                                )
        )
    }
}
