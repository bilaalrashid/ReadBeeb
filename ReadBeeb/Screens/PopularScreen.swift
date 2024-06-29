//
//  PopularScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

/// The screen displaying the most popular story promos and topics.
struct PopularScreen: View {
    /// The sections from the API's main feed to display in the screen.
    private let sectionsToInclude = ["Most Read", "Topics in the news"]

    /// The global view model representing the system.
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
