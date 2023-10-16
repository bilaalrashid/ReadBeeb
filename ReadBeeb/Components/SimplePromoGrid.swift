//
//  SimplePromoGrid.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/10/2023.
//

import SwiftUI

struct SimplePromoGrid: View {
    let item: FDSimplePromoGrid

    var body: some View {
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { index, item in
            if let destination = item.link.destinations.first {
                // Workaround to hide detail disclosure
                ZStack {
                    NavigationLink(destination: DestinationDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                    StoryPromoRow(story: item)
                }
            }
        }
    }
}

#Preview {
    SimplePromoGrid(item: FDSimplePromoGrid(type: "SimplePromoGrid", items: []))
}
