//
//  TopicSelectionViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 29/06/2024.
//

import Foundation
import SwiftData

extension TopicSelectionScreen {
    /// The view model for the topic selection screen.
    @MainActor class ViewModel: ObservableObject {
        /// All the possible topics to select.
        let allTopics: [Topic] = {
            let result = Bundle.main.decode(TopicResult.self, from: "Topics.json")
            return result.topics
        }()

        /// The filtered topics from the user's search query.
        ///
        /// If the search query is empty, then all topics are returned.
        ///
        /// - Parameter searchText: The text of the search query.
        /// - Returns: The filtered topics.
        func topics(for searchText: String) -> [Topic] {
            if searchText.isEmpty {
                return self.allTopics
            }

            return self.allTopics.filter {
                return $0.headline.localizedCaseInsensitiveContains(searchText)
                || $0.subhead?.localizedCaseInsensitiveContains(searchText) ?? false
                || $0.id.localizedCaseInsensitiveContains(searchText)
            }
        }

        /// Returns a topic if it is included in the user's selection.
        ///
        /// - Parameters:
        ///   - topic: The topic to check.
        ///   - selectedTopics: The user's selected topics.
        /// - Returns: The topic, if it is included in the user's selection.
        func selectedTopic(for topic: Topic, selectedTopics: [Topic]) -> Topic? {
            return selectedTopics.first { $0.id == topic.id }
        }

        /// Toggles selection for a given topic.
        ///
        /// If the topic is currently selected, it will be removed from the selection. If it isn't, then the topic will be added to the
        /// selection.
        ///
        /// - Parameters:
        ///   - topic: The topic to toggle the selection for.
        ///   - selectedTopics: The user's selected topics.
        ///   - modelContext: The model context which the topics are stored in.
        func toggleTopicSelection(topic: Topic, selectedTopics: [Topic], modelContext: ModelContext) {
            if let existingTopic = self.selectedTopic(for: topic, selectedTopics: selectedTopics) {
                modelContext.delete(existingTopic)
            } else {
                modelContext.insert(topic)
            }
        }
    }
}
