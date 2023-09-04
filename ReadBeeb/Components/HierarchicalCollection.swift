//
//  HierarchicalCollection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct HierarchicalCollection: View {
    let item: BBCNewsAPIFederatedDiscoveryDataItem

    var body: some View {
        if let items = self.item.items {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if let destination = item.link.destinations.first {
                    // Workaround to hide detail disclosure
                    ZStack {
                        NavigationLink(destination: NewsStoryDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                        NewsStoryRow(story: item)
                    }
                }
            }
        }
    }
}

struct HierarchicalCollectionItem_Previews: PreviewProvider {
    static var previews: some View {
        HierarchicalCollection(item:
                                    BBCNewsAPIFederatedDiscoveryDataItem(
                                        type: "HierarchicalCollection",
                                        items: nil,
                                        text: nil,
                                        link: nil,
                                        period: nil,
                                        location: nil,
                                        forecast: nil,
                                        aspectRatio: nil,
                                        presentation: nil,
                                        hasPageIndicator: nil,
                                        trackedEvents: nil,
                                        title: nil,
                                        subtitle: nil,
                                        buttons: nil,
                                        lastUpdated: nil
                                    )
        )
    }
}
