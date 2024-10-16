//
//  MyNewsViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import BbcNews
import OSLog
import UIKit

extension MyNewsScreen {
    /// The view model for the My News screen.
    @MainActor class ViewModel: ObservableObject {
        /// The story promos to display in the view.
        @Published private(set) var storyPromos = [FDStoryPromo]()

        /// The status of the network request.
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        /// If the results from the API are empty.
        var isEmpty: Bool {
            return self.storyPromos.isEmpty
        }

        /// Fetch all story promos for specified topics, if the data hasn't already been fetched.
        ///
        /// - Parameter selectedTopics: The topics to fetch the story promos for.
        func fetchDataIfNotExists(selectedTopics: [Topic]) async {
            // We don't want to start another network request if there is already one ongoing
            if self.networkRequest != .loading && self.isEmpty {
                await self.fetchData(selectedTopics: selectedTopics)
            }
        }

        /// Fetch all story promos from the API for specified topics.
        ///
        /// - Parameter selectedTopics: The topics to fetch the story promos for.
        func fetchData(selectedTopics: [Topic]) async {
            self.networkRequest = .loading

            let ids = selectedTopics.map { $0.id }

            let service = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.service)
            let api = BbcNews(
                modelIdentifier: UIDevice.current.modelIdentifier,
                systemName: UIDevice.current.systemName,
                systemVersion: UIDevice.current.systemVersion,
                service: Service(rawValue: service ?? "") ?? .english
            )

            let result = await api.fetchTopicDiscoveryPages(for: ids)

            switch result {
            case .success(let topicResults):
                let storyPromos = self.storyPromos(for: topicResults)

                self.storyPromos = storyPromos
                    .filter { $0.updated != nil || $0.isLive }
                    .sorted { ($0.updated ?? .now) > ($1.updated ?? .now) }

                self.networkRequest = .success
            case .failure(let error):
                self.networkRequest = .error
                Logger.network.error("Unable to fetch my news topics: \(error.localizedDescription)")
            }
        }

        /// Gets all story promos from a set of topic discovery page contents.
        ///
        /// - Parameter topicResults: The contents of the topic discovery pages.
        /// - Returns: A unique list of all story promos found.
        private func storyPromos(for topicResults: [FDResult]) -> [FDStoryPromo] {
            var storyPromos = Set<FDStoryPromo>()

            for result in topicResults {
                storyPromos.formUnion(result.data.storyPromos)
            }

            return Array(storyPromos)
        }
    }
}
