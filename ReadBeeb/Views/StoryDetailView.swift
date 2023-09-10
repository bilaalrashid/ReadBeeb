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

    @State private var shouldDisplayNetworkError = false

    var body: some View {
        List {
            if let data = self.data {
                ForEach(Array(data.data.items.enumerated()), id: \.offset) { index, item in
                    switch item {
                    case .media(let item):
                        EmptyView()
                    case .image(let item):
                        EmptyView()
                    case .headline(let item):
                        EmptyView()
                    case .textContainer(let item):
                        TextContainer(container: item)
                    case .sectionHeader(let item):
                        EmptyView()
                    case .carousel(let item):
                        EmptyView()
                    case .contentList(let item):
                        EmptyView()
                    case .storyPromo(let item):
                        EmptyView()
                    default:
                        EmptyView()
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
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
