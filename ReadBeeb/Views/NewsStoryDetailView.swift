//
//  NewsStoryDetailView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/09/2023.
//

import SwiftUI
import OSLog

struct NewsStoryDetailView: View {

    let destination: BBCNewsAPIFDFluffyDestination

    @State private var data: BBCNewsAPIFDResult? = nil

    @State private var shouldDisplayNetworkError = false

    var body: some View {
        Text("Hello, World!")
            .listStyle(.plain)
            .alert(
                "Unable To Load Data",
                isPresented: self.$shouldDisplayNetworkError,
                actions: { Button("OK", role: .cancel) { } },
                message: { Text("Please try again later and contact support if the problem persists") }
            )
            .refreshable {
                Task {
                    await self.fetchData()
                }
            }
            .onAppear {
                Task {
                    await self.fetchData()
                }
            }
    }

    private func fetchData() async {
        do {
            let result = try await BBCNewsAPINetworkController.fetchFDUrl(url: self.destination.url)
            self.data = result
        } catch let error {
            self.shouldDisplayNetworkError = true
            Logger.network.error("Unable to fetch news article \(self.destination.url) - \(error.localizedDescription)")
        }
    }
    
}

struct NewsStoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsStoryDetailView(destination:
                                BBCNewsAPIFDFluffyDestination(
                                    sourceFormat: .abl,
                                    url: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset",
                                    id: "/news/world-europe-66631182",
                                    presentation: BBCNewsAPIFDFluffyPresentation(
                                        type: .singleRenderer,
                                        canShare: true,
                                        focusedItemIndex: nil,
                                        contentSource: nil,
                                        title: nil
                                    )
                                )
        )
    }
}
