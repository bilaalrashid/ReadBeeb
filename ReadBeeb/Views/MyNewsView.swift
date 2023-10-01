//
//  MyNewsView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct MyNewsView: View {

    @State private var isEditingTopics = false

    var body: some View {
        List {

        }
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
