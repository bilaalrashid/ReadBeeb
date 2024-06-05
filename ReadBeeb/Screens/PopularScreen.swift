//
//  PopularScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

struct PopularScreen: View {
    private let sectionsToInclude = ["Most Read", "Topics in the news"]

    @EnvironmentObject var viewModel: GlobalViewModel

    var body: some View {
        VStack {
            if let result = self.viewModel.result {
                DiscoveryView(data: result.data, sectionsToInclude: self.sectionsToInclude)
            }
        }
        .navigationTitle("Popular")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
        .refreshable {
            await self.viewModel.fetchData()
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists()
            }
        }
    }
}
