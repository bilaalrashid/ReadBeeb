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
import BbcNews

struct StoryView: View {
    let data: FDResult

    /// A destination that the story can link to e.g. a discovery page or another story.
    @State private var destination: FDLinkDestination?
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
                case .imageContainer(let item):
                    ImageContainer(imageContainer: item)
                        .modify {
                            if index == 0 {
                                $0.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                            } else {
                                $0
                            }
                        }
                        .onTapGesture {
                            self.detailImageToShow = item.image
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
                    Headline(headline: item, destination: self.$destination)
                case .byline(let item):
                    Byline(byline: item)
                case .textContainer(let item):
                    TextContainer(container: item, destination: self.$destination)
                case .sectionHeader(let item):
                    SectionHeader(header: item)
                case .carousel(let item):
                    TextCarousel(carousel: item, destination: self.$destination)
                case .contentList(let item):
                    ContentList(list: item, destination: self.$destination)
                case .storyPromo(let storyPromo):
                    if let destination = storyPromo.link.destinations.first {
                        PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                            StoryPromoRow(story: storyPromo, destination: self.$destination)
                        }
                    }
                case .copyright(let item):
                    Copyright(item: item)
                #if DEBUG
                case .unknown:
                    Text("UNKNOWN value of FDItem decoded")
                        .frame(maxWidth: .infinity)
                        .background(.red)
                #endif
                default:
                    EmptyView()
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationDestination(item: self.$destination) { destination in
            DestinationDetailScreen(destination: destination)
        }
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
                case .imageContainer(let container):
                    return container.image
                case .image(let image):
                    return image
                default:
                    return nil
                }
            }
            .compactMap { $0 }

        return images
            .map { monitor.currentPath.isConstrained ? $0.largestImageUrl(upTo: 400) : $0.largestImageUrl }
            .compactMap { $0 }
    }

    private func mainImages(from data: FDResult) -> [FDImage] {
        return data.data.items
            .map {
                switch $0 {
                case .imageContainer(let container):
                    return container.image
                case .image(let image):
                    return image
                default:
                    return nil
                }
            }
            .compactMap { $0 }
    }
}
