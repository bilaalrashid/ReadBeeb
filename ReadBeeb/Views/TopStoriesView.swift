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
    @State private var networkRequest = NetworkRequestStatus<Void>.notStarted

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
        .overlay(Group {
            switch self.networkRequest {
            case .loading, .notStarted:
                if self.data?.data.structuredItems.isEmpty ?? true {
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
            case .error:
                Text("Unable to load data. Please try again later and contact support if the problem persists.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            case .success(_):
                EmptyView()
            }
        })
        .refreshable {
            Task {
                await self.fetchData()
            }
        }
        .onAppear {
            Task {
                await self.fetchDataIfNotExists()
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
        case .simplePromoGrid(let item):
            SimplePromoGrid(item: item)
        case .copyright(let item):
            Copyright(item: item)
        default:
            EmptyView()
        }
    }

    private func fetchDataIfNotExists() async {
        switch self.networkRequest {
        case .notStarted, .error:
            break
        case .loading:
            return
        case .success(_):
            if self.data?.data.structuredItems.isEmpty ?? true {
                return
            }
        }

        await self.fetchData()
    }

    private func fetchData() async {
        do {
            self.networkRequest = .loading
            let result = try await BBCNewsAPINetworkController.fetchDiscoveryPage()
            self.data = result
            self.networkRequest = .success(())
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
