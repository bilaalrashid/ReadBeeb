//
//  Billboard.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI

struct Billboard: View {
    let item: FDBillboard

    var body: some View {
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { index, item in
            if let destination = item.link.destinations.first {
                // Workaround to hide detail disclosure
                ZStack {
                    NavigationLink(destination: StoryDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                    StoryPromoRow(story: item)
                }
            }
        }
    }
}

#Preview {
    Billboard(item: FDBillboard(type: "Billboard", items: []))
}
