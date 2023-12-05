//
//  PlainNavigationLink.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import SwiftUI

/// A `NavigationLink` with the detail disclosure hidden
struct PlainNavigationLink<Destination: View, Label: View>: View {
    let destination: Destination
    let label: Label

    init(destination: Destination, @ViewBuilder _ label: () -> Label) {
        self.destination = destination
        self.label = label()
    }

    var body: some View {
        // Workaround to hide detail disclosure
        ZStack {
            NavigationLink(destination: self.destination) { EmptyView() }.opacity(0.0)
            self.label
        }
    }
}
