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

    @State private var storyPromos = [FDStoryPromo]()
    @State private var networkRequest = NetworkRequestStatus.notStarted

    @State private var isEditingTopics = false

    var body: some View {
        List {
            ForEach(Array(self.storyPromos.enumerated()), id: \.offset) { index, story in
                if let destination = story.link.destinations.first {
                    // Workaround to hide detail disclosure
                    ZStack {
                        NavigationLink(destination: DestinationDetailScreen(destination: destination)) { EmptyView() }.opacity(0.0)
                        StoryPromoRow(story: story)
                    }
                }
            }

            if self.storyPromos.count > 0 {
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
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.networkRequest, isEmpty: self.storyPromos.isEmpty))
        .sheet(isPresented: self.$isEditingTopics) {
            NavigationStack {
                TopicSelectionScreen()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .refreshable {
            await self.fetchData()
        }
        .onChange(of: self.selectedTopics) {
            Task {
                await self.fetchDataIfNotExists()
            }
        }
        .onAppear {
            Task {
                await self.fetchDataIfNotExists()
            }
        }
    }

    private func fetchDataIfNotExists() async {
        switch self.networkRequest {
        case .notStarted, .error:
            break
        case .loading:
            return
        case .success:
            if !self.storyPromos.isEmpty {
                return
            }
        }

        await self.fetchData()
    }

    private func fetchData() async {
        do {
            self.networkRequest = .loading
            let ids = self.selectedTopics.map { $0.id }
            let result = try await BBCNewsAPINetworkController.fetchStoryPromos(for: ids)
            self.storyPromos = result
            self.networkRequest = .success
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
        MyNewsScreen()
    }
}
