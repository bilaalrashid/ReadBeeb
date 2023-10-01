//
//  TopStoriesView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

struct TopStoriesView: View {

    @State private var data: FDResult? = nil

    @State private var shouldDisplayNetworkError = false

    var body: some View {
        List {
            if let data = self.data {
                ForEach(Array(data.data.structuredItems.enumerated()), id: \.offset) { index, item in
                    if let header = item.header {
                        self.getFDItemView(item: header)
                    }

                    self.getFDItemView(item: item.body)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Top Stories")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .alert(
            "Unable To Load Data",
            isPresented: self.$shouldDisplayNetworkError,
            actions: { Button("OK", role: .cancel) { } },
            message: { Text("Please try again later and contact support if the problem persists") }
        )
        .refreshable {
            Task {
                await self.fetchData()
            }
        }
        .onAppear {
            Task {
                await self.fetchData()
            }
        }
    }

    @ViewBuilder private func getFDItemView(item: FDItem) -> some View {
        switch item {
        case .hierarchicalCollection(let item):
            HierarchicalCollection(item: item)
        case .collectionHeader(let item):
            CollectionHeader(item: item)
        case .simpleCollection(let item):
            SimpleCollection(item: item)
        case .copyright(let item):
            Copyright(item: item)
        default:
            EmptyView()
        }
    }

    private func fetchData() async {
        do {
            let result = try await BBCNewsAPINetworkController.fetchDiscoveryPage()
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
