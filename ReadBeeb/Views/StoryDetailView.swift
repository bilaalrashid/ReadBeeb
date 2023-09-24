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
        VStack(spacing: 0) {
            if BBCNewsAPINetworkController.isAPIUrl(url: self.destination.url) {
                List {
                    if let data = self.data {
                        ForEach(Array(data.data.items.enumerated()), id: \.offset) { index, item in
                            switch item {
                            case .media(let item):
                                MediaView(media: item)
                                    .modify {
                                        if index == 0 {
                                            $0.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                                        } else {
                                            $0
                                        }
                                    }
                            case .image(let item):
                                ImageView(image: item)
                                    .modify {
                                        if index == 0 {
                                            $0.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                                        } else {
                                            $0
                                        }
                                    }
                            case .headline(let item):
                                Headline(headline: item)
                            case .textContainer(let item):
                                TextContainer(container: item)
                            case .sectionHeader(let item):
                                SectionHeader(header: item)
                            case .carousel(let item):
                                EmptyView()
                            case .contentList(let item):
                                ContentList(list: item)
                            case .storyPromo(let item):
                                if let destination = item.link.destinations.first {
                                    // Workaround to hide detail disclosure
                                    ZStack {
                                        NavigationLink(destination: StoryDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                                        StoryPromoRow(story: item)
                                    }
                                }
                            case .copyright(let item):
                                Copyright(item: item)
                            default:
                                EmptyView()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            } else {
                if let url = URL(string: self.destination.url) {
                    StoryWebView(url: url)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let canShare = self.destination.presentation.canShare, canShare {
                    switch self.destination.sourceFormat {
                    case "ABL":
                        if let url = URL(string: "https://bbc.co.uk/" + self.destination.id) {
                            ShareLink(item: url) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                    case "HTML":
                        if let url = URL(string: self.destination.url) {
                            ShareLink(item: url) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
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
            if BBCNewsAPINetworkController.isAPIUrl(url: self.destination.url) {
                let result = try await BBCNewsAPINetworkController.fetchFDUrl(url: self.destination.url)
                self.data = result
            }
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
