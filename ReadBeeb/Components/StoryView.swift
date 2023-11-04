//
//  StoryView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI
import Kingfisher
import Network

struct StoryView: View {
    let data: FDResult

    var body: some View {
        List {
            ForEach(Array(self.data.data.items.enumerated()), id: \.offset) { index, item in
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
                    TextCarousel(carousel: item)
                case .contentList(let item):
                    ContentList(list: item)
                case .storyPromo(let item):
                    if let destination = item.link.destinations.first {
                        // Workaround to hide detail disclosure
                        ZStack {
                            NavigationLink(destination: DestinationDetailScreen(destination: destination)) { EmptyView() }.opacity(0.0)
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
        .listStyle(.plain)
        .onAppear {
            self.prefetchImages()
        }
    }

    private func prefetchImages() {
        let urls = self.imageUrls(from: self.data)
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }

    private func imageUrls(from data: FDResult) -> [URL] {
        let monitor = NWPathMonitor()

        let images: [FDImage] = data.data.items.map {
            switch $0 {
            case .media(let media):
                return media.image
            case .image(let image):
                return image
            default:
                return nil
            }
        }.compactMap { $0 }

        let urls = images.map { monitor.currentPath.isConstrained ? $0.largestImageUrl(upTo: 400) : $0.largestImageUrl }
        return urls.map { URL(string: $0) }.compactMap { $0 }
    }
}

#Preview {
    StoryView(data: FDResult(data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: 0, shareUrl: nil), items: []), contentType: ""))
}
