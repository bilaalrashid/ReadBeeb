//
//  GlobalViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import OSLog

@MainActor class GlobalViewModel: ObservableObject {
    @Published private(set) var data: FDResult? = nil
    @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

    var isEmpty: Bool {
        return self.data?.data.structuredItems.isEmpty ?? true
    }

    func fetchDataIfNotExists() async {
        switch self.networkRequest {
        case .notStarted, .error:
            break
        case .loading:
            return
        case .success:
            if self.isEmpty {
                return
            }
        }

        await self.fetchData()
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
