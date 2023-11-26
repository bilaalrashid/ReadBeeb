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
            let result = try await BBCNewsAPINetworkController.fetchDiscoveryPage(postcode: postcode)

            self.data = result

            self.videoPromos = result.data.storyPromos
                .sorted { ($0.updated ?? 0) > ($1.updated ?? 0) }
                .filter { storyPromo in
                    return storyPromo.link.destinations.first { $0.presentation.type == "VERTICAL_VIDEO" } == nil
                        && storyPromo.badges?.first { $0.type == "VIDEO" } != nil
                }

            self.networkRequest = .success
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }
}
