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
        let destination: FDLinkDestination

        @Published private(set) var data: FDResult?
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        init(destination: FDLinkDestination) {
            self.destination = destination
        }

        var isEmpty: Bool {
            return self.data == nil
        }

        var isApiUrl: Bool {
            return BBCNews.isAPIUrl(url: self.destination.url)
        }

        var isBBCSportUrl: Bool {
            return self.isBBCSportUrl(url: self.destination.url)
        }

        func fetchDataIfNotExists() async {
            // We don't want to start another network request if there is already one ongoing
            if self.networkRequest != .loading && self.isEmpty {
                await self.fetchData()
            }
        }

        func fetchData() async {
            do {
                if self.isApiUrl {
                    self.networkRequest = .loading
                    let result = try await BBCNews().fetchFDUrl(url: self.destination.url)
                    self.data = result
                    self.networkRequest = .success
                }
            } catch let error {
                self.networkRequest = .error
                Logger.network.error("Unable to fetch news article \(self.destination.url) - \(error.localizedDescription)")
            }
        }

        /// Mocks a successful API request by storing fake data and a successful result state
        func mockSuccessfulApiRequest() {
            self.data = FDResult(
                data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: 0, shareUrl: nil), items: []),
                contentType: ""
            )
            self.networkRequest = .success
        }

        private func isBBCSportUrl(url: String) -> Bool {
            return url.contains("https://www.bbc.co.uk/sport/")
        }
    }
}
