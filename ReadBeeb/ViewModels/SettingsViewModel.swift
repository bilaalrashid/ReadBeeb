//
//  SettingsViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 30/06/2024.
//

import Foundation
import OSLog

extension SettingsScreen {
    /// The view model for the settings screen.
    @MainActor class ViewModel: ObservableObject {
        /// The size of the system cache in bytes.
        @Published private(set) var cacheSize = 0

        /// The system cache size, formatted as a human-readable string.
        var formattedCacheSize: String {
            ByteCountFormatter.string(fromByteCount: Int64(self.cacheSize), countStyle: .file)
        }

        /// All possible postcode areas that can be selected.
        let postcodes: [String] = {
            let result = Bundle.main.decode(PostcodeResult.self, from: "Postcodes.json")
            return result.postcodes.map { $0.postcode }
        }()

        /// Fetches the size of the system cache.
        func fetchCacheSize() async {
            let imageCacheSize = try? await ImageCacheController().getCacheSize()
            self.cacheSize = imageCacheSize ?? 0
        }

        /// Clears the system cache.
        func clearCache() {
            self.cacheSize = 0
            ImageCacheController().clearCache()
        }

        func getPostcode() -> String? {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultIdentifiers.postcodeIdentifier)
        }

        /// Saves the inputted postcode to the user-modifiable preferences.
        func savePostcode(rawPostcode: String) {
            let validated = rawPostcode.trimmingCharacters(in: .whitespacesAndNewlines).prefix(7)

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
        }
    }
}
