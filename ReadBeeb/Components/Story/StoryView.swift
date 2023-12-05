//
//  StoryView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI
import Kingfisher
import Network
import LazyPager

struct StoryView: View {
    let data: FDResult

    @State private var detailImageToShow: FDImage?

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
                        .onTapGesture {
                            self.detailImageToShow = item
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
                case .storyPromo(let storyPromo):
                    if let destination = storyPromo.link.destinations.first {
                        PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                            StoryPromoRow(story: storyPromo)
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
        .fullScreenCover(item: self.$detailImageToShow) { image in
            let images = self.mainImages(from: self.data)
            ImageDetailScreen(images: images, index: images.firstIndex(of: image) ?? 0)
        }
    }

    private func prefetchImages() {
        let urls = self.imageUrls(from: self.data)
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }

    private func imageUrls(from data: FDResult) -> [URL] {
        let monitor = NWPathMonitor()

        let images: [FDImage] = data.data.items
            .map {
                switch $0 {
                case .media(let media):
                    return media.image
                case .image(let image):
                    return image
                default:
                    return nil
                }
            }
            .compactMap { $0 }

        let urls = images.map { monitor.currentPath.isConstrained ? $0.largestImageUrl(upTo: 400) : $0.largestImageUrl }
        return urls.map { URL(string: $0) }.compactMap { $0 }
    }

    private func mainImages(from data: FDResult) -> [FDImage] {
        return data.data.items
            .map {
                if case .image(let image) = $0 {
                    return image
                }
                return nil
            }
            .compactMap { $0 }
    }
}
