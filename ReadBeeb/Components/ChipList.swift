//
//  ChipList.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import SwiftUI

struct ChipList: View {
    let item: FDChipList

    var body: some View {
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { index, topic in
            if let title = topic.title, let destination = topic.link?.destinations.first  {
                // Workaround to hide detail disclosure
                ZStack {
                    NavigationLink(destination: DestinationDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
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
