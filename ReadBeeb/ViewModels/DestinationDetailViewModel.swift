//
//  DestinationDetailViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import OSLog

extension DestinationDetailScreen {

    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var data: FDResult? = nil
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        var isEmpty: Bool {
            return self.data == nil
        }

        func fetchData(destination: FDLinkDestination) async {
            do {
                if self.isApiUrl(url: destination.url) {
                    self.networkRequest = .loading
                    let result = try await BBCNewsAPINetworkController.fetchFDUrl(url: destination.url)
                    self.data = result
                    self.networkRequest = .success
                }
            } catch let error {
                self.networkRequest = .error
                Logger.network.error("Unable to fetch news article \(destination.url) - \(error.localizedDescription)")
            }
        }

        /// Mocks a successful API request by storing fake data and a successful result state
        func mockSuccessfulApiRequest() {
            self.data = FDResult(data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: 0, shareUrl: nil), items: []), contentType: "")
            self.networkRequest = .success
        }

        func isApiUrl(url: String) -> Bool {
            return BBCNewsAPINetworkController.isAPIUrl(url: url)
        }

        func isBBCSportUrl(url: String) -> Bool {
            return url.contains("https://www.bbc.co.uk/sport/")
        }
    }

}
