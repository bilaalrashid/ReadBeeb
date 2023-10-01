//
//  MyNewsView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI
import SwiftData
import OSLog

struct MyNewsView: View {

    @Query var selectedTopics: [Topic]

    @State private var isEditingTopics = false
    @State private var networkRequest = NetworkRequestStatus<[FDStoryPromo]>.loading

    var body: some View {
        List {
            if case .success(let storyPromos) = self.networkRequest {
                ForEach(Array(storyPromos.enumerated()), id: \.offset) { index, story in
                    if let destination = story.link.destinations.first {
                        // Workaround to hide detail disclosure
                        ZStack {
                            NavigationLink(destination: StoryDetailView(destination: destination)) { EmptyView() }.opacity(0.0)
                            StoryPromoRow(story: story)
                        }
                    }
                }
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
        .sheet(isPresented: self.$isEditingTopics) {
            NavigationStack {
                TopicSelectionView()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .refreshable {
            Task {
                await self.fetchData()
            }
        }
        .onChange(of: self.selectedTopics) {
            Task {
                await self.fetchData()
            }
        }
        .onAppear {
            Task {
                await self.fetchData()
            }
        }
    }

    private func fetchData() async {
        do {
            let ids = self.selectedTopics.map { $0.id }
            let result = try await BBCNewsAPINetworkController.fetchStoryPromos(for: ids)
            self.networkRequest = .success(result)
        } catch let error {
            self.networkRequest = .error
            Logger.network.error("Unable to fetch topics for My News tab - \(error.localizedDescription)")
        }
    }

    private func editTopics() {
        self.isEditingTopics = true
    }

}

struct MyNewsView_Previews: PreviewProvider {
    static var previews: some View {
        MyNewsView()
    }
}
