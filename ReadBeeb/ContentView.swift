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

            NavigationStack {
                PopularScreen()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Popular", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationStack {
                VideoScreen()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Video", systemImage: "play.rectangle")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
