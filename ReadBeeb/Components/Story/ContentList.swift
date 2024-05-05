//
//  ContentList.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI
import BbcNews

struct ContentList: View {
    let list: FDContentList

    var body: some View {
        ForEach(Array(self.list.listItems.enumerated()), id: \.offset) { index, item in
            TextContainer(
                container: FDTextContainer(type: "textContainer", containerType: "", text: item),
                list: self.list,
                index: index
            )
        }
    }
}

struct ContentList_Previews: PreviewProvider {
    static var previews: some View {
        ContentList(list: FDContentList(type: "ContentList", ordering: "UNORDERED", listItems: []))
    }
}
