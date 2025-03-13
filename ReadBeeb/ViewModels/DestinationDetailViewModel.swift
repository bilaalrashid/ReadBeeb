//
//  DestinationDetailViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import Foundation
import BbcNews
import OSLog
import UIKit

extension DestinationDetailScreen {
    /// The view model for the destination detail screen.
    @MainActor class ViewModel: ObservableObject {
        /// The destination that the detail screen displays.
        @Published private(set) var destination: FDLinkDestination

        /// The data from the network request.
        @Published private(set) var data: FDData?

        /// The status of the network request.
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        /// Attempts to convert a web based destination to one which points to a native destination that can be accessed by the API. If
        /// the destination cannot be converted, it returns the original destination.
        private static func convertDestinationToApiIfNeeded(destination: FDLinkDestination) -> FDLinkDestination {
            // We can't rely on `self.destination.sourceFormat` here, so we must use the presentation type.
            guard destination.presentation.type == .web else {
                return destination
            }

            Logger.network.info("Attempting to rewrite WEB destination \(destination.url)")

            // Live webpages cannot be rewritten and we will get a 404 that we can't handle if we attempt to do so.
            if destination.url.absoluteString.contains("https://www.bbc.co.uk/news/live/") {
                Logger.network.info("WEB destination is a live webpage, we can't rewrite this \(destination.url)")

                return destination
            }

            guard let convertedUrl = BbcNews.convertWebUrlToApi(url: destination.url) else {
                return destination
            }

            Logger.network.info("Rewritten WEB destination to \(convertedUrl)")

            let presentation = FDPresentation(
                type: .singleRenderer,
                title: destination.presentation.title,
                canShare: destination.presentation.canShare,
                contentSource: destination.presentation.contentSource,
                renderLinks: destination.presentation.renderLinks
            )

            return FDLinkDestination(sourceFormat: .abl, url: convertedUrl, id: destination.id, presentation: presentation)
        }

        /// Creates a view model for DestinationDetailScreen.
        ///
        /// This attempts to rewrite any HTML URLs to ABL ones that return JSON responses.
        ///
        /// - Parameter destination: The destination to display in the view.
        init(destination: FDLinkDestination) {
            self.destination = DestinationDetailScreen.ViewModel.convertDestinationToApiIfNeeded(destination: destination)
        }

        /// If the results from the API are empty.
        var isEmpty: Bool {
            return self.data == nil
        }

        /// If the destination URL is served by the BBC Sport brand.
        var isBBCSportUrl: Bool {
            return self.isBBCSportUrl(url: self.destination.url)
        }

        /// The type of the destination to be displayed in the view.
        var destinationType: String? {
            return self.destination.url.valueOf("type")
        }

        /// If the destination URL is served by the BBC News API.
        private var isApiUrl: Bool {
            return BbcNews.isApiUrl(url: self.destination.url)
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

            let service = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.service)
            let api = BbcNews(
                modelIdentifier: UIDevice.current.modelIdentifier,
                systemName: UIDevice.current.systemName,
                systemVersion: UIDevice.current.systemVersion,
                service: Service(rawValue: service ?? "") ?? .english
            )

            let result = await api.fetch(url: self.destination.url)

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
