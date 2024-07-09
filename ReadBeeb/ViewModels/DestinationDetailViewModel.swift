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
    /// The view model for the destination detail screen.
    @MainActor class ViewModel: ObservableObject {
        /// The destination that the detail screen displays.
        @Published private(set) var destination: FDLinkDestination

        /// The data from the network request.
        @Published private(set) var data: FDData?

        /// The status of the network request.
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

        /// If the results from the API are empty.
        var isEmpty: Bool {
            return self.data == nil
        }

        /// If the destination URL is served by the BBC News API.
        var isApiUrl: Bool {
            return BbcNews.isApiUrl(url: self.destination.url)
        }

        /// If the destination URL is served by the BBC Sport brand.
        var isBBCSportUrl: Bool {
            return self.isBBCSportUrl(url: self.destination.url)
        }

        /// The type of the destination to be displayed in the view.
        var destinationType: String? {
            return self.destination.url.valueOf("type")
        }

        /// Fetch the contents of the destination URL from the API, if it haven't already been fetched.
        func fetchDataIfNotExists() async {
            // We don't want to start another network request if there is already one ongoing
            if self.networkRequest != .loading && self.isEmpty {
                await self.fetchData()
            }
        }

        /// Fetch the contents of the destination URL from the API.
        func fetchData() async {
            // Only fetch data if the destination URL is for the API
            guard self.isApiUrl else { return }

            self.networkRequest = .loading

            let result = await BbcNews().fetch(url: self.destination.url)

            switch result {
            case .success(let result):
                self.data = result.data
                self.networkRequest = .success
            case .failure(let error):
                if case .newDestination(_, let link) = error {
                    guard let destination = link.destinations.first else {
                        self.networkRequest = .error
                        Logger.network.error("No destination found inside new destination response: \(error.localizedDescription)")

                        return
                    }

                    Logger.network.info("Found new destination \(destination.url) from \(self.destination.url)")

                    self.destination = destination
                    await self.fetchData()

                    return
                }

                self.networkRequest = .error
                Logger.network.error("Unable to fetch destination: \(error.localizedDescription)")
            }
        }

        /// Mocks a successful API request by storing fake data and a successful result state.
        func mockSuccessfulApiRequest() {
            self.data = FDData(metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: Date(), shareUrl: nil), items: [])
            self.networkRequest = .success
        }

        /// Calculates if a URL is served by the BBC Sport brand.
        ///
        /// - Parameter url: The URL to test.
        /// - Returns: If the URL is served by the BBC Sport brand.
        private func isBBCSportUrl(url: URL) -> Bool {
            return url.absoluteString.contains("https://www.bbc.co.uk/sport/")
        }
    }
}
