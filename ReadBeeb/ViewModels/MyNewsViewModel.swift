//
//  MyNewsViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import OSLog

extension MyNewsScreen {

    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var storyPromos = [FDStoryPromo]()
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        var isEmpty: Bool {
            return self.storyPromos.isEmpty
        }

        func fetchDataIfNotExists(selectedTopics: [Topic]) async {
            // We don't want to start another network request if there is already one ongoing
            if self.networkRequest != .loading && self.isEmpty {
                await self.fetchData(selectedTopics: selectedTopics)
            }
        }

        func fetchData(selectedTopics: [Topic]) async {
            do {
                self.networkRequest = .loading
                let ids = selectedTopics.map { $0.id }
                let result = try await BBCNewsAPINetworkController.fetchStoryPromos(for: ids)
                self.storyPromos = result
                self.networkRequest = .success
            } catch let error {
                self.networkRequest = .error
                Logger.network.error("Unable to fetch topics for My News tab - \(error.localizedDescription)")
            }
        }
    }

}
