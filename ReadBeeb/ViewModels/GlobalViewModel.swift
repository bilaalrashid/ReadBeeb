//
//  GlobalViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import OSLog

@MainActor class GlobalViewModel: ObservableObject {
    @Published private(set) var data: FDResult?
    @Published private(set) var videoPromos = [FDStoryPromo]()
    @Published private(set) var networkRequest = NetworkRequestStatus.notStarted
    private var isExtraVideosLoaded = false

    var isEmpty: Bool {
        return self.data?.data.structuredItems.isEmpty ?? true
    }

    func fetchDataIfNotExists() async {
        // We don't want to start another network request if there is already one ongoing
        if self.networkRequest != .loading && self.isEmpty {
            await self.fetchData()
        }
    }

    func fetchData() async {
        do {
            self.networkRequest = .loading

            let postcode = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
            let result = try await BbcNews().fetchIndexDiscoveryPage(postcode: postcode)

            self.data = result

            // Don't include linked here, this will be too long to load for all pages
            await self.fetchAllVideos(includeLinked: false)

            self.networkRequest = .success
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }

    func fetchAllVideosIfNotExists() async {
        if !self.isExtraVideosLoaded {
            await self.fetchAllVideos()
        }
    }

    func fetchAllVideos(includeLinked: Bool = true) async {
        guard let data = self.data else { return }

        var storyPromos = Set<FDStoryPromo>()

        storyPromos.formUnion(data.data.storyPromos)

        if includeLinked {
            let linkedStoryPromos = await self.fetchLinkedStoryPromos(for: data)
            storyPromos.formUnion(linkedStoryPromos)
        }

        let videoPromos = Array(storyPromos).filter { storyPromo in
            return storyPromo.link.destinations.first { $0.presentation.type == "VERTICAL_VIDEO" } == nil
            && storyPromo.badges?.first { $0.type == "VIDEO" } != nil
        }

        self.videoPromos = videoPromos.sorted { ($0.updated ?? 0) > ($1.updated ?? 0) }

        if includeLinked {
            self.isExtraVideosLoaded = true
        }
    }

    private func fetchLinkedStoryPromos(for data: FDResult) async -> Set<FDStoryPromo> {
        let headers = data.data.structuredItems.compactMap { $0.header }

        let urls = headers.compactMap {
            switch $0 {
            case .collectionHeader(let header):
                return header.link?.destinations.first?.url
            default:
                return nil
            }
        }

        var storyPromos = Set<FDStoryPromo>()

        for url in urls {
            do {
                let result = try await BbcNews().fetchFDUrl(url: url)
                storyPromos.formUnion(result.data.storyPromos)
            } catch let error {
                self.networkRequest = .error
                Logger.network.error("Unable to fetch \(url) - \(error.localizedDescription)")
            }
        }

        return storyPromos
    }
}
