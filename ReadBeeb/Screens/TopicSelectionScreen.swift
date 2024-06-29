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

    /// The currently selected topics.
    @Query var selectedTopics: [Topic]

    /// The search query for topics.
    @State private var searchText = ""

    /// If the search experience is currently active.
    @State private var isSearchActive = false

    /// All the possible topics to select.
    let allTopics: [Topic] = {
        let result = Bundle.main.decode(TopicResult.self, from: "Topics.json")
        return result.topics
    }()

    /// The filtered topics from the user's search query.
    ///
    /// If the search query is empty, then all topics are returned.
    var filteredTopics: [Topic] {
        if self.searchText.isEmpty {
            return self.allTopics
        } else {
            return self.allTopics.filter {
                return $0.headline.localizedCaseInsensitiveContains(self.searchText)
                || $0.subhead?.localizedCaseInsensitiveContains(self.searchText) ?? false
                || $0.id.localizedCaseInsensitiveContains(self.searchText)
            }
        }
    }

    var body: some View {
        List {
            Section(header: Text("")) {
                ForEach(self.isSearchActive ? self.filteredTopics : self.selectedTopics, id: \.id) { topic in
                    HStack {
                        if self.isTopicSelected(topic: topic) {
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
                            self.toggleTopicSelection(topic: topic)
                        }
                    }
                }
            }
        }
        .searchable(text: self.$searchText, isPresented: self.$isSearchActive, placement: .navigationBarDrawer(displayMode: .always))
        .listStyle(.insetGrouped)
        .navigationTitle("My Topics")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            Button(action: {
                self.dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    // System tint color overrides the toolbar color scheme, so the color needs explicitly defining
                    .foregroundStyle(.white)
            }
        }
    }

    /// Returns a topic if it is included in the user's selection.
    ///
    /// - Parameter topic: The topic to check.
    /// - Returns: The topic, if it is included in the user's selection.
    private func selectedTopic(for topic: Topic) -> Topic? {
        return self.selectedTopics.first { $0.id == topic.id }
    }

    /// Checks if a given topic is in the user's selection.
    ///
    /// - Parameter topic: The topic to check.
    /// - Returns: If the topic is in the user's selection.
    private func isTopicSelected(topic: Topic) -> Bool {
        return self.selectedTopic(for: topic) != nil
    }

    /// Toggles selection for a given topic.
    ///
    /// If the topic is currently selected, it will be removed from the selection. If it isn't, then the topic will be added to the
    /// selection.
    ///
    /// - Parameter topic: The topic to toggle the selection for.
    private func toggleTopicSelection(topic: Topic) {
        if let existingTopic = self.selectedTopic(for: topic) {
            self.modelContext.delete(existingTopic)
        } else {
            self.modelContext.insert(topic)
        }
    }
}

#Preview {
    TopicSelectionScreen()
}
