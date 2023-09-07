//
//  FDItem.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import SwiftUI

struct FDItem: View {
    let item: BBCNewsAPIFDDataItem

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

struct FDItem_Previews: PreviewProvider {
    static var previews: some View {
        FDItem(item:
                                BBCNewsAPIFDDataItem(
                                    type: "CollectionHeader",
                                    items: nil,
                                    text: .string("News from London"),
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
                                    lastUpdated: nil,
                                    source: nil,
                                    image: nil,
                                    metadata: nil,
                                    byline: nil,
                                    topic: nil,
                                    languageCode: nil,
                                    readTimeMinutes: nil,
                                    containerType: nil,
                                    ordering: nil,
                                    listItems: nil,
                                    style: nil,
                                    subtext: nil,
                                    updated: nil
                                )
        )
    }
}
