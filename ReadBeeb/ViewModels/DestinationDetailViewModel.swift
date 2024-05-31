//
//  DestinationDetailViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import BbcNews
import OSLog

extension DestinationDetailScreen {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var destination: FDLinkDestination
        @Published private(set) var data: FDResult?
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        /// Creates a view model for DestinationDetailScreen.
        ///
        /// This attempts to rewrite any HTML URLs to ABL ones that return JSON responses.
        ///
        /// - Parameter destination: The destination to display in the view.
        init(destination: FDLinkDestination) {
            if !BbcNews.isApiUrl(url: destination.url), let apiUrl = BbcNews.convertWebUrlToApi(url: destination.url) {
                self.destination = FDLinkDestination(
                    sourceFormat: .abl,
                    url: apiUrl,
                    id: destination.id,
                    presentation: destination.presentation
                )
            } else {
                self.destination = destination
            }
        }

        var isEmpty: Bool {
            return self.data == nil
        }

        var isApiUrl: Bool {
            return BbcNews.isApiUrl(url: self.destination.url)
        }

        var isBBCSportUrl: Bool {
            return self.isBBCSportUrl(url: self.destination.url)
        }

        /// The type of the destination to be displayed in the view.
        var destinationType: String? {
            if let url = URL(string: self.destination.url) {
                return url.valueOf("type")
            }

            return nil
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
                    let result = try await BbcNews().fetch(url: self.destination.url)
                    self.data = result
                    self.networkRequest = .success
                }
            } catch NetworkError.newDestination(let link) {
                if let destination = link.destinations.first {
                    Logger.network.info("Found new destination \(destination.url) from \(self.destination.url)")
                    self.destination = destination
                    await self.fetchData()
                }
            } catch let error {
                self.networkRequest = .error
                Logger.network.error("Unable to fetch news article \(self.destination.url) - \(error.localizedDescription)")
            }
        }

        /// Mocks a successful API request by storing fake data and a successful result state
        func mockSuccessfulApiRequest() {
            self.data = FDResult(
                data: FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: Date(), shareUrl: nil), items: []),
                contentType: ""
            )
            self.networkRequest = .success
        }

        private func isBBCSportUrl(url: String) -> Bool {
            return url.contains("https://www.bbc.co.uk/sport/")
        }
    }
}
