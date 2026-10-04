//
//  DiscoveryView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI
import BbcNews

/// A view that displays the contents of a discovery page.
struct DiscoveryView: View {
    /// The data representing the discovery page.
    let data: FDData

    /// The sections from the API's main feed to include in the view.
    ///
    /// This takes priority over `sectionsToExclude`
    let sectionsToInclude: [String]?

    /// The sections from the API's main feed to exclude from the view.
    ///
    /// This has a lower priority than `sectionsToInclude`.
    let sectionsToExclude: [String]?

    /// How carousel groups that contain news videos are selected.
    ///
    /// Applied after the header include and exclude lists.
    let videoCarousels: VideoCarouselSelection

    /// The collection headers to move to the front of the list, in this order.
    ///
    /// Applied after the header and video-carousel filters.
    let pinnedHeaders: [String]?

    /// If the row separator should be hidden.
    let shouldHideSeparators: Bool

    /// Extra content to be displayed after the main feeds and before the copyright disclaimer.
    ///
    /// `AnyView` is used to avoid specifying dummy generic type when there is no extra content.
    @ViewBuilder var extraContent: () -> AnyView?

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @State private var destination: FDLinkDestination?

    /// Creates a new view that displays the contents of a discovery page.
    ///
    /// - Parameters:
    ///   - data: The data representing the discovery page.
    ///   - sectionsToInclude: The sections from the API's main feed to include in the view.
    ///   - sectionsToExclude: The sections from the API's main feed to exclude from the view.
    ///   - videoCarousels: How carousel groups that contain news videos are selected.
    ///   - pinnedHeaders: The collection headers to move to the front after the header and video-carousel filters.
    ///   - shouldHideSeparators: If the row separator should be hidden.
    ///   - extraContent: Extra content to be displayed after the main feeds and before the copyright disclaimer.
    init(
        data: FDData,
        sectionsToInclude: [String]? = nil,
        sectionsToExclude: [String]? = nil,
        videoCarousels: VideoCarouselSelection = .any,
        pinnedHeaders: [String]? = nil,
        shouldHideSeparators: Bool = false,
        extraContent: @escaping () -> AnyView? = { nil }
    ) {
        self.data = data
        self.sectionsToInclude = sectionsToInclude
        self.sectionsToExclude = sectionsToExclude
        self.videoCarousels = videoCarousels
        self.pinnedHeaders = pinnedHeaders
        self.shouldHideSeparators = shouldHideSeparators
        self.extraContent = extraContent
    }

    /// The item groups from the API, including or excluding any specified sections.
    ///
    /// Header include takes priority over header exclude. Video-carousel selection then runs. Matching headers are
    /// moved to the front when a pin list is given. Groups whose remaining promos all link to non-news BBC services
    /// are omitted.
    private var filteredItemGroups: [FDItemGroup] {
        self.data.itemGroups.filtered(
            including: self.sectionsToInclude,
            excluding: self.sectionsToExclude,
            videoCarousels: self.videoCarousels,
            pinnedHeaders: self.pinnedHeaders
        )
    }

    var body: some View {
        List {
            ForEach(Array(self.filteredItemGroups.enumerated()), id: \.offset) { index, group in
                if let header = group.header {
                    DiscoveryItemView(item: header, index: index, hasHeader: false, destination: self.$destination)
                }

                DiscoveryItemView(item: group.body, index: index, hasHeader: group.header != nil, destination: self.$destination)
            }
            .listRowSeparator(self.shouldHideSeparators ? .hidden : .automatic)

            self.extraContent()

            Copyright(item: FDCopyright(lastUpdated: Date()))
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationDestination(item: self.$destination) { destination in
            DestinationDetailScreen(destination: destination)
        }
    }
}

#Preview {
    DiscoveryView(
        data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: Date(), shareUrl: nil), items: []),
        sectionsToInclude: nil,
        sectionsToExclude: nil
    ) {
        AnyView(Text("Extra Row"))
    }
}
