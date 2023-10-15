//
//  PopularView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

struct PopularView: View {
    
    @State private var mostRead: FDStructuredDataItem?
    @State private var networkRequest = NetworkRequestStatus.notStarted

    var body: some View {
        List {
            if let header = self.mostRead?.header {
                self.getFDItemView(item: header)
            }

            if let body = self.mostRead?.body {
                self.getFDItemView(item: body)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Popular")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.networkRequest, isEmpty: self.mostRead == nil))
        .refreshable {
            await self.fetchData()
        }
        .onAppear {
            Task {
                await self.fetchDataIfNotExists()
            }
        }
    }

    @ViewBuilder private func getFDItemView(item: FDItem) -> some View {
        switch item {
        case .billboard(let item):
            Billboard(item: item)
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
        case .success:
            if self.mostRead == nil {
                return
            }
        }

        await self.fetchData()
    }

    private func fetchData() async {
        do {
            self.networkRequest = .loading
            let result = try await BBCNewsAPINetworkController.fetchDiscoveryPage()

            if let mostRead = result.data.structuredItems.including(headers: ["Most Read"]).first {
                self.mostRead = mostRead
                self.networkRequest = .success
            } else {
                self.networkRequest = .error
                Logger.network.error("Most Read section not included in the BBC News API Home tab")
            }
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }

}

struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        PopularView()
    }
}
