//
//  TopStoriesView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

struct TopStoriesView: View {

    @State private var data: BBCNewsAPIFederatedDiscoveryResult? = nil

    @State private var shouldDisplayNetworkError = false

    var body: some View {
        List {
            if let data = self.data {
                ForEach(Array(data.data.items.enumerated()), id: \.offset) { index, item in
                    switch item.type {
                    case "HierarchicalCollection":
                        HierarchicalCollectionItem(item: item)
                    case "CollectionHeader":
                        CollectionHeaderItem(item: item)
                    case "SimpleCollection":
                        SimpleCollectionItem(item: item)
                    case "WeatherPromoSummary":
                        EmptyView()
                    case "Carousel":
                        EmptyView()
                    case "ChipList":
                        EmptyView()
                    case "CallToActionBanner":
                        EmptyView()
                    case "Copyright":
                        EmptyView()
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .alert(
            "Unable To Load Data",
            isPresented: self.$shouldDisplayNetworkError,
            actions: { Button("OK", role: .cancel) { } },
            message: { Text("Please try again later and contact support if the problem persists") }
        )
        .onAppear {
            Task {
                await self.fetchData()
            }
        }
    }

    private func fetchData() async {
        do {
            let result = try await BBCNewsAPINetworkController.fetchHomeTabData()
            self.data = result
        } catch let error {
            self.shouldDisplayNetworkError = true
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }

}

struct TopStoriesView_Previews: PreviewProvider {
    static var previews: some View {
        TopStoriesView()
    }
}
