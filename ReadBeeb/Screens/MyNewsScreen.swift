//
//  MyNewsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import SwiftData
import OSLog

struct MyNewsScreen: View {

    @Query var selectedTopics: [Topic]
    @StateObject private var viewModel = ViewModel()

    @State private var isEditingTopics = false

    var body: some View {
        List {
            ForEach(Array(self.viewModel.storyPromos.enumerated()), id: \.offset) { index, story in
                if let destination = story.link.destinations.first {
                    // Workaround to hide detail disclosure
                    ZStack {
                        NavigationLink(destination: DestinationDetailScreen(destination: destination)) { EmptyView() }.opacity(0.0)
                        StoryPromoRow(story: story)
                    }
                }
            }

            if self.viewModel.storyPromos.count > 0 {
                Copyright(item: FDCopyright(type: "Copyright", lastUpdated: Int(Date().timeIntervalSince1970) * 1000))
            }
        }
        .listStyle(.plain)
        .navigationTitle("My News")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: self.editTopics) {
                    Label("Edit", systemImage: "ellipsis.circle")
                }
            }
        }
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
        .sheet(isPresented: self.$isEditingTopics) {
            NavigationStack {
                TopicSelectionScreen()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .refreshable {
            await self.viewModel.fetchData(selectedTopics: self.selectedTopics)
        }
        .onChange(of: self.selectedTopics) {
            Task {
                await self.viewModel.fetchDataIfNotExists(selectedTopics: self.selectedTopics)
            }
        }
        .onAppear {
            Task {
                await self.viewModel.fetchDataIfNotExists(selectedTopics: self.selectedTopics)
            }
        }
    }

    private func editTopics() {
        self.isEditingTopics = true
    }

}

struct MyNewsView_Previews: PreviewProvider {
    static var previews: some View {
        MyNewsScreen()
    }
}
