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
    private let sectionsToExclude = [
        "Watch & Listen",
        "Most Read",
        "Topics in the news",
        "Today's videos",
        "The video playlist",
        "Copyright",
        "برامجنا",                           // Arabic: "Our Programs"
        "فيديو",                             // Arabic: "Video"
        "الأكثر قراءة",                       // Arabic: "Most Read"
        "مواقعنا على وسائل التواصل الاجتماعي", // Arabic: "Our Social Media Sites"
        "Gwylio a Gwrando",                  // Cymru: "Watch and Listen"
        "Dysgu Cymraeg",                     // Cymru: "Learn Welsh"
        "Hefyd ar y we",                     // Cymru: "Also on the web"
        "मल्टीमीडिया",                           // Hindi: "Multimedia"
        "पॉडकास्ट",                             // Hindi: "Podcast"
        "सबसे अधिक पढ़ी गईं",                    // Hindi: "Most Read"
        "Video y audio",                     // Mundo: "Video and audio"
        "Más leídas",                        // Mundo: "Most Read"
        "En redes sociales",                 // Mundo: "On social networks"
        "Подкасты",                          // Russian: "Podcasts"
        "Самое популярное",                  // Russian: "Most Popular"
        "Мы в соцсетях",                     // Russian: "We are in social networks"
        "Полезные ссылки"                   // Russian: "Useful links"
    ]

    /// The global view model representing the system.
    @EnvironmentObject var viewModel: GlobalViewModel

    /// If the screen is modally displaying the settings screen.
    @State private var isShowingSettings = false

    var body: some View {
        VStack {
            if let data = self.viewModel.data {
                DiscoveryView(data: data, sectionsToExclude: self.sectionsToExclude)
            }
        }
        .navigationTitle("Top Stories")
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
