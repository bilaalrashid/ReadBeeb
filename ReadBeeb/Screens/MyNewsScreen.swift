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

struct MyNewsScreen: View {
    @Query var selectedTopics: [Topic]
    @StateObject private var viewModel = ViewModel()

    @State private var isEditingTopics = false

    var body: some View {
        List {
            ForEach(Array(self.viewModel.storyPromos.enumerated()), id: \.offset) { _, storyPromo in
                if let destination = storyPromo.link.destinations.first {
                    PlainNavigationLink(destination: DestinationDetailScreen(destination: destination)) {
                        StoryPromoRow(story: storyPromo)
                    }
                }
            }

            if !self.viewModel.storyPromos.isEmpty {
                Copyright(item: FDCopyright(type: "Copyright", lastUpdated: Int(Date().timeIntervalSince1970) * 1000))
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("My News")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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
