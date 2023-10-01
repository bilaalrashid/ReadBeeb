//
//  TopicSelectionView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/10/2023.
//

import SwiftUI
import SwiftData

struct TopicSelectionView: View {

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Query var selectedTopics: [Topic]

    let allTopics: [Topic] = {
        let result = Bundle.main.decode(TopicResult.self, from: "Topics.json")
        return result.topics
    }()

    var body: some View {
        List {
            ForEach(self.allTopics, id: \.id) { topic in
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
    TopicSelectionView()
}
