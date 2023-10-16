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
            if let title = topic.title {
                Text(title)
                    .foregroundStyle(Constants.primaryColor)
            }
        }
    }
}

#Preview {
    ChipList(item: FDChipList(type: "ChipList", items: []))
}
