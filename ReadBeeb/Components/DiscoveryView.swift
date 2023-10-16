//
//  DiscoveryView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI

struct DiscoveryView: View {
    let data: FDResult

    var body: some View {
        List {
            ForEach(Array(data.data.structuredItems.enumerated()), id: \.offset) { index, item in
                if let header = item.header {
                    DiscoveryItemView(item: header)
                }

                DiscoveryItemView(item: item.body)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    DiscoveryView(data: FDResult(data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: 0, shareUrl: nil), items: []), contentType: ""))
}
