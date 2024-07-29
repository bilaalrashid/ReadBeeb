//
//  RootView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 26/08/2023.
//

import SwiftUI
import BbcNews

/// The root view of the system for an individual window.
struct RootView: View {
    /// The global view model representing the system.
    @StateObject private var viewModel = GlobalViewModel()

    /// The international service that results are being fetched for.
    @AppStorage(Constants.UserDefaultIdentifiers.service)
    private var service = Service.english.rawValue

    var body: some View {
        TabView {
            NavigationStack {
                TopStoriesScreen()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Top Stories", systemImage: "doc.richtext")
            }

            NavigationStack {
                MyNewsScreen()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("My News", systemImage: "person.crop.square")
            }

            if self.service != Service.cymru.rawValue {
                NavigationStack {
                    PopularScreen()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Popular", systemImage: "chart.line.uptrend.xyaxis")
                }
            }

            NavigationStack {
                VideoScreen()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Video", systemImage: "play.rectangle")
            }
        }
        .environmentObject(self.viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
