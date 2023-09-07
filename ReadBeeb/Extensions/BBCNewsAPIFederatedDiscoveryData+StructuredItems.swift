//
//  BBCNewsAPIFDData+StructuredItems.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import Foundation

extension BBCNewsAPIFDData {

    struct BBCNewsAPIFDStructuredDataItem {
        var header: BBCNewsAPIFDDataItem?
        var body: BBCNewsAPIFDDataItem
    }

    var structuredItems: [BBCNewsAPIFDStructuredDataItem] {
        let headerTypes = ["CollectionHeader"]

        var structuredItems = [BBCNewsAPIFDStructuredDataItem]()
        var currentHeader: BBCNewsAPIFDDataItem?

        for item in self.items {
            // This will discard any header without a body that follows it, as we're not interested in them
            if headerTypes.contains(item.type) {
                currentHeader = item
            } else {
                structuredItems.append(BBCNewsAPIFDStructuredDataItem(header: currentHeader, body: item))
                currentHeader = nil
            }
        }

        return structuredItems
    }

}
