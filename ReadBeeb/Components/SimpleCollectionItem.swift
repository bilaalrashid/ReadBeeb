//
//  SimpleCollectionItem.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct SimpleCollectionItem: View {
    let item: BBCNewsAPIHomeTabDataItem

    var body: some View {
        Text("Hello, World!")
    }
}

struct SimpleCollectionItem_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCollectionItem(item:
                                BBCNewsAPIHomeTabDataItem(
                                    type: "SimpleCollection",
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