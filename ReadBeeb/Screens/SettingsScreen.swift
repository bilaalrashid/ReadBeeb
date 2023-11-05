//
//  SettingsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Section {
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
    }

    private func clearCache() {
        ImageCacheController().clearCache()
    }
}

#Preview {
    SettingsScreen()
}
