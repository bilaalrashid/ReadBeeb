//
//  ReadBeebApp.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 26/08/2023.
//

import SwiftUI
import SwiftData

@main
struct ReadBeebApp: App {
    init() {
        ImageCacheController().setMaximumCacheSize()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Constants.primaryColor)
        }
        .modelContainer(for: Topic.self)
    }
}
