//
//  SimpleCollection.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct SimpleCollection: View {
    let item: FDSimpleCollection

    var body: some View {
        ForEach(Array(self.item.items.enumerated()), id: \.offset) { index, item in
            StoryPromoRow(story: item)
        }
    }
}

struct SimpleCollectionItem_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCollection(item: FDSimpleCollection(type: "SimpleCollection", items: []))
    }
}
