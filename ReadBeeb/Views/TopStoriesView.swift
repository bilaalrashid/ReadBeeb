//
//  TopStoriesView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

struct TopStoriesView: View {

    private let sectionsToExclude = ["Watch & Listen", "Most Read", "Topics in the news"]

    @State private var structuredItems = [FDStructuredDataItem]()
    @State private var networkRequest = NetworkRequestStatus.notStarted

    var body: some View {
        List {
            ForEach(Array(self.structuredItems.enumerated()), id: \.offset) { index, item in
                if let header = item.header {
                    DiscoveryView(item: header)
                }

                DiscoveryView(item: item.body)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Top Stories")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.networkRequest, isEmpty: self.structuredItems.isEmpty))
        .refreshable {
            await self.fetchData()
        }
        .onAppear {
            Task {
                await self.fetchDataIfNotExists()
            }
        }
    }

    private func fetchDataIfNotExists() async {
        switch self.networkRequest {
        case .notStarted, .error:
            break
        case .loading:
            return
        case .success:
            if self.structuredItems.isEmpty {
                return
            }
        }

        await self.fetchData()
    }

    private func fetchData() async {
        do {
            self.networkRequest = .loading
            let result = try await BBCNewsAPINetworkController.fetchDiscoveryPage()
            self.structuredItems = result.data.structuredItems.excluding(headers: self.sectionsToExclude)
            self.networkRequest = .success
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }

}

struct TopStoriesView_Previews: PreviewProvider {
    static var previews: some View {
        TopStoriesView()
    }
}
