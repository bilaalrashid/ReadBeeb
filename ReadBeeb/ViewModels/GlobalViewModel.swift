//
//  GlobalViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import BbcNews
import OSLog
import UIKit

/// The global view model for the system.
@MainActor class GlobalViewModel: ObservableObject {
    /// The data from the main network request of the API.
    @Published private(set) var data: FDData?

    /// A list of story promos that link to video-only stories.
    @Published private(set) var videoPromos = [FDStoryPromo]()

    /// The status of the main network request.
    @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

    /// If videos, in addition to the main network request, have been fetched from the API.
    private var isExtraVideosLoaded = false

    /// If the results from the API are empty.
    var isEmpty: Bool {
        return self.data?.itemGroups.isEmpty ?? true
    }

    /// Fetch the main data for the view model, if it hasn't been fetched before.
    func fetchDataIfNotExists() async {
        // We don't want to start another network request if there is already one ongoing
        if self.networkRequest != .loading && self.isEmpty {
            await self.fetchData()
        }
    }

    /// Fetch the main data for the view model from the API.
    func fetchData() async {
        self.networkRequest = .loading

        let postcode = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
        let service = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.service)
        let api = BbcNews(
            modelIdentifier: UIDevice.current.modelIdentifier,
            systemName: UIDevice.current.systemName,
            systemVersion: UIDevice.current.systemVersion,
            service: Service(rawValue: service ?? "") ?? .english
        )

        let result = await api.fetchIndexDiscoveryPage(postcode: postcode)

        switch result {
        case .success(let result):
            self.data = result.data

            // Don't include linked here, this will be too long to load for all pages
            await self.fetchAllVideos(includeLinked: false)

            self.networkRequest = .success
        case .failure(let error):
            self.networkRequest = .error
            Logger.network.error("Unable to fetch home page: \(error.localizedDescription)")
        }
    }

    /// Fetch all videos for this view model, if they haven't been fetched before.
    func fetchAllVideosIfNotExists() async {
        if !self.isExtraVideosLoaded {
            await self.fetchAllVideos()
        }
    }

    /// Fetch all videos for this view model.
    ///
    /// - Parameter includeLinked: If videos should be fetched from linked discovery pages.
    func fetchAllVideos(includeLinked: Bool = true) async {
        guard let data = self.data else { return }

        var storyPromos = Set<FDStoryPromo>()

        storyPromos.formUnion(data.storyPromos)

        if includeLinked {
            let linkedStoryPromos = await self.fetchLinkedStoryPromos(for: data)
            storyPromos.formUnion(linkedStoryPromos)
        }

        let videoPromos = Array(storyPromos).filter { storyPromo in
            return storyPromo.link.destinations.first { $0.presentation.type == .verticalVideo } == nil
            && storyPromo.badges?.first { $0.type == .video } != nil
        }

        self.videoPromos = videoPromos.sorted { ($0.updated ?? Date()) > ($1.updated ?? Date()) }

        if includeLinked {
            self.isExtraVideosLoaded = true
        }
    }

    /// Fetch all story promos from linked discovery pages.
    ///
    /// - Parameter data: The API data that defines the linked discovery pages to fetch.
    /// - Returns: All story promos found.
    private func fetchLinkedStoryPromos(for data: FDData) async -> Set<FDStoryPromo> {
        let headers = data.itemGroups.compactMap { $0.header }

        let urls = headers.compactMap {
            switch $0 {
            case .collectionHeader(let header):
                return header.link?.destinations.first?.url
            default:
                return nil
            }
        }

        var storyPromos = Set<FDStoryPromo>()

        let service = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.service)
        let api = BbcNews(
            modelIdentifier: UIDevice.current.modelIdentifier,
            systemName: UIDevice.current.systemName,
            systemVersion: UIDevice.current.systemVersion,
            service: Service(rawValue: service ?? "") ?? .english
        )

        for url in urls {
            let result = await api.fetch(url: url)

            switch result {
            case .success(let result):
                storyPromos.formUnion(result.data.storyPromos)
            case .failure(let error):
                self.networkRequest = .error
                Logger.network.error("Unable to fetch linked story promo: \(error.localizedDescription)")
            }
        }

        return storyPromos
    }
}
