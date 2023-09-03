//
//  BBCNewsAPIFederatedDiscoveryData+StructuredItems.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/09/2023.
//

import Foundation

extension BBCNewsAPIFederatedDiscoveryData {

    struct BBCNewsAPIFederatedDiscoveryStructuredDataItem {
        var header: BBCNewsAPIFederatedDiscoveryDataItem?
        var body: BBCNewsAPIFederatedDiscoveryDataItem
    }

    var structuredItems: [BBCNewsAPIFederatedDiscoveryStructuredDataItem] {
        let headerTypes = ["CollectionHeader"]

        var structuredItems = [BBCNewsAPIFederatedDiscoveryStructuredDataItem]()
        var currentHeader: BBCNewsAPIFederatedDiscoveryDataItem?

        for item in self.items {
            // This will discard any header without a body that follows it, as we're not interested in them
            if headerTypes.contains(item.type) {
                currentHeader = item
            } else {
                structuredItems.append(BBCNewsAPIFederatedDiscoveryStructuredDataItem(header: currentHeader, body: item))
                currentHeader = nil
            }
        }

        return structuredItems
    }

}
