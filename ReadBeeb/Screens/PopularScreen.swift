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
    private let sectionsToInclude = [
        "Most Read",
        "Topics in the news",
        "الأكثر قراءة",                       // Arabic: "Most Read"
        "सबसे अधिक पढ़ी गईं",                    // Hindi: "Most Read"
        "Más leídas",                        // Mundo: "Most Read"
        "Самое популярное"                   // Russian: "Most Popular"
    ]

    /// The global view model representing the system.
    @EnvironmentObject var viewModel: GlobalViewModel

    var body: some View {
        VStack {
            if let data = self.viewModel.data {
                DiscoveryView(data: data, sectionsToInclude: self.sectionsToInclude)
            }
        }
        .navigationTitle("Popular")
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
