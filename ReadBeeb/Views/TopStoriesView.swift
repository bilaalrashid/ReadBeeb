//
//  TopStoriesView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import SwiftUI

struct TopStoriesView: View {

    @State private var data: BBCNewsAPIHomeTabResult? = nil

    var body: some View {
        List {

        }
        .onAppear {
            Task {
                do {
                    let result = try await BBCNewsAPINetworkController.fetchHomeTabData()
                    self.data = result
                } catch let error {
                    // Noop
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
