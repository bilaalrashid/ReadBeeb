//
//  MyNewsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import SwiftData
import BbcNews
import OSLog

/// The screen displaying a feed of story promos from topics that the user can subscribe to.
struct MyNewsScreen: View {
    /// The currently selected topics.
    @Query var selectedTopics: [Topic]

    /// The view model representing the screen.
    @StateObject private var viewModel = ViewModel()

    /// A secondary destination that the story promo can link to e.g. a topic discovery page.
    @State private var destination: FDLinkDestination?

    /// If the user is currently editing the topic selection.
    @State private var isEditingTopics = false

    var body: some View {
        List {
            ForEach(Array(self.viewModel.storyPromos.enumerated()), id: \.offset) { _, storyPromo in
                if let destination = storyPromo.link.destinations.first {
                    PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                        StoryPromoRow(story: storyPromo, destination: self.$destination)
                    }
                }
            }

            if !self.viewModel.storyPromos.isEmpty {
                Copyright(item: FDCopyright(lastUpdated: Date()))
                    .listRowSeparator(.hidden)
            }
        }
        .navigationDestination(item: self.$destination) { destination in
            DestinationDetailScreen(destination: destination)
        }
        .listStyle(.plain)
        .navigationTitle("My News")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    self.isEditingTopics = true
                }) {
                    Label("Edit", systemImage: "ellipsis.circle")
                }
            }
        }
        .overlay(
            VStack {
                if self.selectedTopics.isEmpty {
                    Text("Select topics to follow in your personalised feed")
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    Button("Select Topics") {
                        self.isEditingTopics = true
                    }
                } else {
                    NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty)
                }
            }
        )
        .refreshable {
            await self.viewModel.fetchData(selectedTopics: self.selectedTopics)
        }
        .onChange(of: self.selectedTopics) {
            Task {
                await self.viewModel.fetchData(selectedTopics: self.selectedTopics)
            }
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists(selectedTopics: self.selectedTopics)
            }
        }
        .sheet(isPresented: self.$isEditingTopics) {
            NavigationStack {
                TopicSelectionScreen()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct MyNewsView_Previews: PreviewProvider {
    static var previews: some View {
        MyNewsScreen()
    }
}
