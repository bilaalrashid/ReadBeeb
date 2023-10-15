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
                DiscoveryView(item: header)
            }

            if let body = self.mostRead?.body {
                DiscoveryView(item: body)
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
            self.mostRead = result.data.structuredItems.including(headers: ["Most Read"]).first
            self.networkRequest = .success
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
