//
//  DiscoveryView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI
import BbcNews

struct DiscoveryView: View {
    let data: FDResult
    let sectionsToInclude: [String]?
    let sectionsToExclude: [String]?
    let shouldHideSeparators: Bool
    /// Use AnyView to avoid specifying dummy generic type when there is no extra content
    @ViewBuilder var extraContent: () -> AnyView?

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @State private var destination: FDLinkDestination?

    init(
        data: FDResult,
        sectionsToInclude: [String]? = nil,
        sectionsToExclude: [String]? = nil,
        shouldHideSeparators: Bool = false,
        extraContent: @escaping () -> AnyView? = { nil }
    ) {
        self.data = data
        self.sectionsToInclude = sectionsToInclude
        self.sectionsToExclude = sectionsToExclude
        self.shouldHideSeparators = shouldHideSeparators
        self.extraContent = extraContent
    }

    var filteredStructuredItems: [FDStructuredDataItem] {
        if let sectionsToInclude = self.sectionsToInclude {
            return self.data.data.structuredItems.including(headers: sectionsToInclude)
        }

        if let sectionsToExclude = self.sectionsToExclude {
            return self.data.data.structuredItems.excluding(headers: sectionsToExclude)
        }

        return self.data.data.structuredItems
    }

    var body: some View {
        List {
            ForEach(Array(self.filteredStructuredItems.enumerated()), id: \.offset) { index, item in
                if let header = item.header {
                    DiscoveryItemView(item: header, index: index, hasHeader: false, destination: self.$destination)
                }

                DiscoveryItemView(item: item.body, index: index, hasHeader: item.header != nil, destination: self.$destination)
            }
            .listRowSeparator(self.shouldHideSeparators ? .hidden : .automatic)

            self.extraContent()

            Copyright(item: FDCopyright(lastUpdated: Int(Date().timeIntervalSince1970) * 1000))
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
        data: FDResult(
            data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: 0, shareUrl: nil), items: []),
            contentType: ""
        ),
        sectionsToInclude: nil,
        sectionsToExclude: nil
    ) {
        AnyView(Text("Extra Row"))
    }
}
