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
    @EnvironmentObject var viewModel: GlobalViewModel
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
                        .autocorrectionDisabled(true)
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
        let validated = self.rawPostcode.trimmingCharacters(in: .whitespacesAndNewlines).prefix(7)
        var toMatch = ""
        if validated.count == 6 || validated.count == 7 {
            toMatch = String(validated.prefix(validated.count - 3))
        } else {
            toMatch = String(validated)
        }

        // Don't write to disk and refresh the view model if there is no change
        let previousValue = UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier) ?? ""
        guard toMatch != previousValue else { return }

        let match = self.postcodes.first {
            $0.localizedCaseInsensitiveContains(toMatch)
        }

        if let match = match {
            UserDefaults.standard.setValue(match, forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
        } else if toMatch.isEmpty {
            UserDefaults.standard.setValue(nil, forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
        }

        Task {
            await self.viewModel.fetchData()
        }
    }
}

#Preview {
    SettingsScreen()
}
