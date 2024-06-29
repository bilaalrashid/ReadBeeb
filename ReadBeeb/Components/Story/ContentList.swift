//
//  ContentList.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a content list in a story.
struct ContentList: View {
    /// The content list to display.
    let list: FDContentList

    /// A destination that the text container can link to e.g. another story.
    @Binding var destination: FDLinkDestination?

    var body: some View {
        ForEach(Array(self.list.listItems.enumerated()), id: \.offset) { index, item in
            TextContainer(
                container: FDTextContainer(containerType: .body, text: item),
                list: self.list,
                index: index,
                destination: self.$destination
            )
        }
    }
}

struct ContentList_Previews: PreviewProvider {
    static var previews: some View {
        ContentList(list: FDContentList(ordering: .unordered, listItems: []), destination: .constant(nil))
    }
}
