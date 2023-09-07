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
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Top Stories", systemImage: "doc.richtext")
            }

            NavigationStack {
                MyNewsView()
                    .navigationTitle("My News")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("My News", systemImage: "person.crop.square")
            }

            NavigationStack {
                PopularView()
                    .navigationTitle("Popular")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Popular", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationStack {
                VideoView()
                    .navigationTitle("Video")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Video", systemImage: "play.rectangle")
            }

            NavigationStack {
                SearchView()
                    .navigationTitle("Search")
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
