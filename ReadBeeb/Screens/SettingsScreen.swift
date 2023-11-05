//
//  SettingsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI

struct SettingsScreen: View {
    let postcodes: [String] = {
        let result = Bundle.main.decode(PostcodeResult.self, from: "Postcodes.json")
        return result.postcodes.map { $0.postcode }
    }()

    @Environment(\.dismiss) var dismiss
    @State private var rawPostcode = ""
    @State private var cacheSize = 0

    var formattedCacheSize: String {
        ByteCountFormatter.string(fromByteCount: Int64(self.cacheSize), countStyle: .file)
    }

    var body: some View {
        List {
            Section(
                footer: Text("Optional. Personalise news results based on your local area.")
            ) {
                HStack {
                    Text("Postcode Area")
                    Spacer()
                    TextField("e.g. W1A", text: self.$rawPostcode)
                        .multilineTextAlignment(.trailing)
                }
            }

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
            self.calculateCacheSize()
            self.loadPostcode()
        }
        .onDisappear {
            self.savePostcode()
        }
    }

    private func calculateCacheSize() {
        Task {
            self.cacheSize = (try? await ImageCacheController().getCacheSize()) ?? 0
        }
    }

    private func clearCache() {
        self.cacheSize = 0
        ImageCacheController().clearCache()
    }

    private func loadPostcode() {
        self.rawPostcode = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier) ?? ""
    }

    private func savePostcode() {
        let trimmed = self.rawPostcode.trimmingCharacters(in: .whitespacesAndNewlines)

        if self.postcodes.contains(trimmed) {
            UserDefaults.standard.setValue(trimmed, forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
        } else if trimmed.isEmpty {
            UserDefaults.standard.setValue(nil, forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
        }
    }
}

#Preview {
    SettingsScreen()
}
