//
//  SettingsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI

/// The screen that controls the user-modifiable preferences.
struct SettingsScreen: View {
    /// An action that dismisses the current presentation.
    @Environment(\.dismiss) var dismiss

    /// The view model representing the screen.
    @EnvironmentObject var globalViewModel: GlobalViewModel

    /// The view model representing the screen.
    @StateObject private var viewModel = ViewModel()

    /// The postcode entered by the user.
    @State private var rawPostcode = ""

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
                footer: Text("Currently using \(self.viewModel.formattedCacheSize).")
            ) {
                Button("Clear Cache") {
                    self.viewModel.clearCache()
                }
                .foregroundColor(.red)
            }

            Section(
                footer: NavigationLink("A Bilaal Rashid project") {
                    LogScreen()
                }
                    .buttonStyle(.plain)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            ) {}
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
            self.fetchPostcode()

            Task {
                await self.viewModel.fetchCacheSize()
            }
        }
        .onDisappear {
            self.viewModel.savePostcode(rawPostcode: self.rawPostcode)

            Task {
                await self.globalViewModel.fetchData()
            }
        }
    }

    /// Fetches the currently stored postcode.
    private func fetchPostcode() {
        self.rawPostcode = self.viewModel.getPostcode() ?? ""
    }
}

#Preview {
    SettingsScreen()
}
