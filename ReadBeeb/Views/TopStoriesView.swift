//
//  TopStoriesView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct TopStoriesView: View {

    @State private var data: BBCNewsAPIHomeTabResult? = nil

    @State private var shouldDisplayNetworkError = false

    var body: some View {
        List {

        }
        .alert(
            "Unable To Load Data",
            isPresented: self.$shouldDisplayNetworkError,
            actions: { Button("OK", role: .cancel) { } },
            message: { Text("Please try again later and contact support if the problem persists") }
        )
        .onAppear {
            Task {
                do {
                    let result = try await BBCNewsAPINetworkController.fetchHomeTabData()
                    self.data = result
                } catch let error {
                    self.shouldDisplayNetworkError = true
                }
            }
        }
    }

}

struct TopStoriesView_Previews: PreviewProvider {
    static var previews: some View {
        TopStoriesView()
    }
}
