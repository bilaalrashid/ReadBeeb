//
//  ChipList.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a chip list.
struct ChipList: View {
    /// The chip list to display.
    let item: FDChipList

    var body: some View {
        ForEach(Array(self.item.topics.enumerated()), id: \.offset) { _, topic in
            if let title = topic.title, let destination = topic.link?.destinations.first {
                PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                    Text(title)
                        .foregroundStyle(Constants.primaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

#Preview {
    ChipList(item: FDChipList(topics: []))
}
