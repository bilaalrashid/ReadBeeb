//
//  ContentView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 26/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TopStoriesView()
                    .navigationTitle("Top Stories")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Constants.primaryColor, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Top Stories", systemImage: "doc.richtext")
            }

            NavigationStack {
                MyNewsView()
                    .navigationTitle("My News")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Constants.primaryColor, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("My News", systemImage: "person.crop.square")
            }

            NavigationStack {
                PopularView()
                    .navigationTitle("Popular")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Constants.primaryColor, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Popular", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationStack {
                VideoView()
                    .navigationTitle("Video")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Constants.primaryColor, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Video", systemImage: "play.rectangle")
            }

            NavigationStack {
                SearchView()
                    .navigationTitle("Search")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Constants.primaryColor, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
