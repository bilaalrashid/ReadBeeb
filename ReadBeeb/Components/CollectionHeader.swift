//
//  CollectionHeader.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct CollectionHeader: View {
    let item: BBCNewsAPIFederatedDiscoveryDataItem

    var body: some View {
        if let text = self.item.text {
            Text(text)
        }
    }
}

struct CollectionHeaderItem_Previews: PreviewProvider {
    static var previews: some View {
        CollectionHeader(item:
                                BBCNewsAPIFederatedDiscoveryDataItem(
                                    type: "CollectionHeader",
                                    items: nil,
                                    text: "News from London",
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
