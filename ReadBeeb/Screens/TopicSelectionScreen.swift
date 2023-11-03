//
//  TopicSelectionScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/10/2023.
//

import SwiftUI
import SwiftData

struct TopicSelectionScreen: View {

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Query var selectedTopics: [Topic]

    @State private var searchText = ""
    @State private var isSearchActive = false

    let allTopics: [Topic] = {
        let result = Bundle.main.decode(TopicResult.self, from: "Topics.json")
        return result.topics
    }()

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
        .searchable(text: self.$searchText, isPresented: self.$isSearchActive)
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

    private func selectedTopic(for topic: Topic) -> Topic? {
        return self.selectedTopics.first { $0.id == topic.id }
    }

    private func isTopicSelected(topic: Topic) -> Bool {
        return self.selectedTopic(for: topic) != nil
    }

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
