//
//  SettingsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var cacheSize = 0

    var formattedCacheSize: String {
        ByteCountFormatter.string(fromByteCount: Int64(self.cacheSize), countStyle: .file)
    }

    var body: some View {
        List {
            Section(
                footer: Text("Currently using \(self.formattedCacheSize).")
            ) {
                Button("Clear Cache") {
                    self.clearCache()
                }
                .foregroundColor(.red)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Profile")
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
        .onAppear {
            Task {
                self.cacheSize = (try? await ImageCacheController().getCacheSize()) ?? 0
            }
        }
    }

    private func clearCache() {
        self.cacheSize = 0
        ImageCacheController().clearCache()
    }
}

#Preview {
    SettingsScreen()
}
