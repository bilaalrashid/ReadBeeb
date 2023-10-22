//
//  FDData+StructuredItems.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

extension FDData {
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

struct FDStructuredDataItem {
    var header: FDItem?
    var body: FDItem
}

extension Array<FDStructuredDataItem> {

    /// Filters out any sections to exclude any that do not match the specified headers
    /// - Parameter includableHeaders: The headers of sections that will not be filtered out
    /// - Returns: The filtered items
    /// - Note: `"Copyright"`is treated as a special-case section header
    func including(headers includableHeaders: [String]) -> [FDStructuredDataItem] {
        return self.filter {
            if case .copyright = $0.body {
                return includableHeaders.contains("Copyright")
            }

            guard let header = $0.header else { return false }
            guard case .collectionHeader(let collectionHeader) = header else { return false }
            return includableHeaders.contains(collectionHeader.text)
        }
    }

    /// Filters out any sections to exclude any that match the specified headers
    /// - Parameter excludableHeaders: The headers of sections to filter out
    /// - Returns: The filtered items
    /// - Note: `"Copyright"`is treated as a special-case section header
    func excluding(headers excludableHeaders: [String]) -> [FDStructuredDataItem] {
        return self.filter {
            if case .copyright = $0.body {
                return !excludableHeaders.contains("Copyright")
            }

            guard let header = $0.header else { return true }
            guard case .collectionHeader(let collectionHeader) = header else { return true }
            return !excludableHeaders.contains(collectionHeader.text)
        }
    }

}
