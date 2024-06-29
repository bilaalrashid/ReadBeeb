//
//  TopStoriesScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import OSLog

/// The screen displaying story promos for the most relevant stories.
struct TopStoriesScreen: View {
    /// The sections from the API's main feed to exclude from display in the screen.
    private let sectionsToExclude = ["Watch & Listen", "Most Read", "Topics in the news", "Today's videos", "Copyright"]

    /// The global view model representing the system.
    @EnvironmentObject var viewModel: GlobalViewModel

    /// If the screen is modally displaying the settings screen.
    @State private var isShowingSettings = false

    var body: some View {
        VStack {
            if let result = self.viewModel.result {
                DiscoveryView(data: result.data, sectionsToExclude: self.sectionsToExclude)
            }
        }
        .navigationTitle("Top Stories")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    self.isShowingSettings = true
                }) {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            }
        }
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
        .refreshable {
            await self.viewModel.fetchData()
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists()
            }
        }
        .sheet(isPresented: self.$isShowingSettings) {
            NavigationStack {
                SettingsScreen()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
