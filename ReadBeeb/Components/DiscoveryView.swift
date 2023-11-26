//
//  DiscoveryView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI

struct DiscoveryView: View {
    let data: FDResult
    let sectionsToInclude: [String]?
    let sectionsToExclude: [String]?
    @ViewBuilder var content: () -> AnyView?

    init(data: FDResult, sectionsToInclude: [String]?, sectionsToExclude: [String]?, content: @escaping () -> AnyView? = { nil }) {
        self.data = data
        self.sectionsToInclude = sectionsToInclude
        self.sectionsToExclude = sectionsToExclude
        self.content = content
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
                    DiscoveryItemView(item: header, index: index)
                }

                DiscoveryItemView(item: item.body, index: index)
            }

            self.content()

            Copyright(item: FDCopyright(type: "Copyright", lastUpdated: Int(Date().timeIntervalSince1970) * 1000))
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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
