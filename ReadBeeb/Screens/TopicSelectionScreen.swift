//
//  TopicSelectionScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/10/2023.
//

import SwiftUI
import SwiftData

/// The screen where the user can selection topics to follow in the My News screen.
struct TopicSelectionScreen: View {
    /// The SwiftData model context that will be used for queries and other model operations within this environment.
    @Environment(\.modelContext) var modelContext

    /// An action that dismisses the current presentation.
    @Environment(\.dismiss) var dismiss

    /// The view model representing the screen.
    @StateObject private var viewModel = ViewModel()

    /// The currently selected topics.
    @Query var selectedTopics: [Topic]

    /// The search query for topics.
    @State private var searchText = ""

    /// If the search experience is currently active.
    @State private var isSearchActive = false

    var body: some View {
        List {
            Section(header: Text("")) {
                ForEach(self.isSearchActive ? self.viewModel.topics(for: self.searchText) : self.selectedTopics, id: \.id) { topic in
                    HStack {
                        if self.viewModel.selectedTopic(for: topic, selectedTopics: self.selectedTopics) != nil {
                            Image(systemName: "checkmark.square.fill")
                            // Color.accentColor is not working here
                                .foregroundStyle(Constants.primaryColor)
                        } else {
                            Image(systemName: "square")
                            // Color.accentColor is not working here
                                .foregroundStyle(Constants.primaryColor)
                        }

                        VStack {
                            Text(topic.headline)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if let subhead = topic.subhead {
                                Text(subhead)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .onTapGesture {
                        withAnimation {
                            self.viewModel.toggleTopicSelection(
                                topic: topic,
                                selectedTopics: self.selectedTopics,
                                modelContext: self.modelContext
                            )
                        }
                    }
                }
            }
        }
        .searchable(text: self.$searchText, isPresented: self.$isSearchActive)
        .listStyle(.insetGrouped)
        .navigationTitle("My Topics")
        .toolbar {
            if #available(iOS 26.0, *) {
                Button(role: .close) {
                    self.dismiss()
                }
            } else {
                Button(action: {
                    self.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    TopicSelectionScreen()
}
