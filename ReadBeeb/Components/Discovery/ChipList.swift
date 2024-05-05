//
//  ChipList.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI
import BbcNews

struct ChipList: View {
    let item: FDChipList

    var body: some View {
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { _, topic in
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
    ChipList(item: FDChipList(type: "ChipList", items: []))
}
