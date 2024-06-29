//
//  ReadBeebApp.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 26/08/2023.
//

import SwiftUI
import SwiftData

/// The ReedBeeb app.
@main
struct ReadBeebApp: App {
    /// Creates a new ReedBeeb app.
    init() {
        ImageCacheController().setMaximumCacheSize()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .accentColor(Constants.primaryColor)
        }
        .modelContainer(for: Topic.self)
    }
}
