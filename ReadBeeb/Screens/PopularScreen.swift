//
//  PopularScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

struct PopularScreen: View {
    
    private let sectionsToInclude = ["Most Read", "Topics in the news", "Copyright"]

    @State private var data: FDResult? = nil
    @State private var networkRequest = NetworkRequestStatus.notStarted

    var body: some View {
        VStack {
            if let data = data {
                DiscoveryView(data: data, sectionsToInclude: self.sectionsToInclude, sectionsToExclude: nil)
            }
        }
        .navigationTitle("Popular")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.networkRequest, isEmpty: self.data?.data.structuredItems.isEmpty ?? true))
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
            self.networkRequest = .success
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch BBC News API Home tab - \(error.localizedDescription)")
        }
    }

}

struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        PopularScreen()
    }
}
