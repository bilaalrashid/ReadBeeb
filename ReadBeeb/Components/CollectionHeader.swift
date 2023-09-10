//
//  CollectionHeader.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct CollectionHeader: View {
    let item: FDCollectionHeader

    var body: some View {
        Text(self.item.text)
            .font(.title3.bold())
    }
}

struct CollectionHeaderItem_Previews: PreviewProvider {
    static var previews: some View {
        CollectionHeader(item: FDCollectionHeader(type: "CollectionHeader", text: "News from London", link: FDLink(destinations: [])))
    }
}
