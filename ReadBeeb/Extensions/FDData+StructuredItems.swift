//
//  FDData+StructuredItems.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

extension FDData {

    struct FDStructuredDataItem {
        var header: FDItem?
        var body: FDItem
    }

    var structuredItems: [FDStructuredDataItem] {
        var structuredItems = [FDStructuredDataItem]()
        var currentHeader: FDItem?

        for item in self.items {
            // This will discard any header without a body that follows it, as we're not interested in them
            switch item {
            case .collectionHeader(_):
                currentHeader = item
            default:
                structuredItems.append(FDStructuredDataItem(header: currentHeader, body: item))
                currentHeader = nil
            }
        }

        return structuredItems
    }

}
