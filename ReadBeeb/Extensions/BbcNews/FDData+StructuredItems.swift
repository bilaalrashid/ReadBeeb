//
//  FDData+StructuredItems.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation
import BbcNews

/// How carousel groups that contain news videos are selected for a discovery screen.
enum VideoCarouselSelection {
    /// Keep only carousel groups that contain news videos.
    case only

    /// Omit carousel groups that contain news videos.
    case exclude

    /// Leave video carousels subject to the header include and exclude lists.
    case any
}

extension FDData {
    /// The list of ordered items to be displayed to the user, grouped with their headers.
    ///
    /// This will ignore any header that is not followed by a body.
    var itemGroups: [FDItemGroup] {
        var groups = [FDItemGroup]()
        var currentHeader: FDItem?

        for item in self.items {
            // This will discard any header without a body that follows it, as we're not interested in them
            switch item {
            case .collectionHeader:
                currentHeader = item
            default:
                groups.append(FDItemGroup(header: currentHeader, body: item))
                currentHeader = nil
            }
        }

        return groups
    }
}

extension Array<FDItemGroup> {
    /// Filters groups for a discovery screen.
    ///
    /// Header include takes priority over header exclude. Video-carousel selection then runs. Matching headers are
    /// moved to the front when a pin list is given. Groups whose remaining promos all link to non-news BBC services
    /// are omitted.
    ///
    /// - Parameters:
    ///   - includableHeaders: The headers of sections that will not be filtered out
    ///   - excludableHeaders: The headers of sections to filter out, used when there is no include list
    ///   - videoCarousels: How carousel groups that contain news videos are selected
    ///   - pinnedHeaders: The collection header texts to move to the front, in this order
    /// - Returns: The filtered groups
    func filtered(
        including includableHeaders: [String]? = nil,
        excluding excludableHeaders: [String]? = nil,
        videoCarousels: VideoCarouselSelection = .any,
        pinnedHeaders: [String]? = nil
    ) -> [FDItemGroup] {
        var groups: [FDItemGroup]

        if let includableHeaders {
            groups = self.including(headers: includableHeaders)
        } else if let excludableHeaders {
            groups = self.excluding(headers: excludableHeaders)
        } else {
            groups = self
        }

        switch videoCarousels {
        case .only:
            groups = groups.includingVideoCarousels()
        case .exclude:
            groups = groups.excludingVideoCarousels()
        case .any:
            break
        }

        if let pinnedHeaders {
            groups = groups.pinningFirst(headers: pinnedHeaders)
        }

        return groups.excludingHiddenPromoGroups()
    }

    /// Filters out any sections to exclude any that do not match the specified headers.
    ///
    /// - Parameter includableHeaders: The headers of sections that will not be filtered out
    /// - Returns: The filtered items
    /// - Note: `"Copyright"`is treated as a special-case section header
    func including(headers includableHeaders: [String]) -> [FDItemGroup] {
        return self.filter {
            if case .copyright = $0.body {
                return includableHeaders.contains("Copyright")
            }

            guard let headerText = $0.headerText else { return false }
            return includableHeaders.contains(headerText)
        }
    }

    /// Filters out any sections to exclude any that match the specified headers.
    ///
    /// - Parameter excludableHeaders: The headers of sections to filter out
    /// - Returns: The filtered items
    /// - Note: `"Copyright"`is treated as a special-case section header
    func excluding(headers excludableHeaders: [String]) -> [FDItemGroup] {
        return self.filter {
            if case .copyright = $0.body {
                return !excludableHeaders.contains("Copyright")
            }

            guard let headerText = $0.headerText else { return true }
            return !excludableHeaders.contains(headerText)
        }
    }

    /// Filters to carousel groups that contain news videos.
    ///
    /// - Returns: The video carousel groups
    func includingVideoCarousels() -> [FDItemGroup] {
        return self.filter(\.isVideoCarousel)
    }

    /// Filters out carousel groups that contain news videos.
    ///
    /// - Returns: The groups that are not news video carousels
    func excludingVideoCarousels() -> [FDItemGroup] {
        return self.filter { !$0.isVideoCarousel }
    }

    /// Moves groups whose collection header matches any of `headers` to the front.
    ///
    /// Matching groups follow the order of `headers`. Other groups keep their original order.
    ///
    /// - Parameter headers: The collection header texts to pin, in the order they should appear
    /// - Returns: The groups with matching headers first
    func pinningFirst(headers: [String]) -> [FDItemGroup] {
        var pinned = [FDItemGroup]()
        var remaining = Array(self)

        for header in headers {
            pinned.append(contentsOf: remaining.filter { $0.headerText == header })
            remaining.removeAll { $0.headerText == header }
        }

        return pinned + remaining
    }

    /// Filters out collection groups whose remaining promos all link to non-news BBC services.
    ///
    /// - Returns: The groups that still have content to display
    func excludingHiddenPromoGroups() -> [FDItemGroup] {
        return self.filter(\.hasVisiblePromos)
    }
}
