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
            let result = try await BBCNewsAPINetworkController.fetchDiscoveryPage()
            self.data = result
            self.networkRequest = .success
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }
}
