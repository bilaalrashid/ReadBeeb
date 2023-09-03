//
//  FederatedDiscoveryItem.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI

struct FederatedDiscoveryItem: View {
    let item: BBCNewsAPIFederatedDiscoveryDataItem

    var body: some View {
        switch item.type {
        case "HierarchicalCollection":
            HierarchicalCollection(item: item)
        case "CollectionHeader":
            CollectionHeader(item: item)
        case "SimpleCollection":
            SimpleCollection(item: item)
        case "WeatherPromoSummary":
            EmptyView()
        case "Carousel":
            EmptyView()
        case "ChipList":
            EmptyView()
        case "CallToActionBanner":
            EmptyView()
        case "Copyright":
            EmptyView()
        default:
            EmptyView()
        }
    }
}

struct FederatedDiscoveryItem_Previews: PreviewProvider {
    static var previews: some View {
        FederatedDiscoveryItem(item:
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
