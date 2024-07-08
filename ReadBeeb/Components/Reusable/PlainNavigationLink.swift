//
//  PlainNavigationLink.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import SwiftUI

/// A `NavigationLink` with the detail disclosure hidden.
struct PlainNavigationLink<Destination: View, Label: View>: View {
    /// A view for the navigation link to present.
    let destination: Destination

    /// A view builder to produce a label describing the destination to present.
    let label: Label

    /// Creates a new navigation link with a hidden detail disclosure.
    ///
    /// - Parameters:
    ///   - destination: The view for the navigation link to present.
    ///   - _: The view builder to produce a label describing the destination to present.
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
