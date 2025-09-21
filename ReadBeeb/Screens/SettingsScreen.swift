//
//  SettingsScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI
import BbcNews

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

    /// The international service that results are being fetched for.
    @AppStorage(Constants.UserDefaultIdentifiers.service)
    private var service = Service.english.rawValue

    /// The text displayed as a footer
    var footerText: String {
        let credit = "A Bilaal Rashid project"

        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return credit
        }

        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return credit
        }

        return "Version \(version) (\(build))\n\(credit)"
    }

    var body: some View {
        List {
            Section {
                Picker("International Service", selection: self.$service) {
                    ForEach(Service.allCases, id: \.rawValue) { service in
                        Text(service.displayName).tag(service.rawValue)
                    }
                }
            }

            if self.service == Service.english.rawValue {
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
            }

            Section(
                footer: Text("Currently using \(self.viewModel.formattedCacheSize).")
            ) {
                Button(action: {
                    self.viewModel.clearCache()
                }) {
                    Label("Clear Cache", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }

            Section(
                footer: NavigationLink(self.footerText) {
                    LogScreen()
                }
                    .buttonStyle(.plain)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            ) {}
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Profile")
        .toolbar {
            if #available(iOS 26.0, *) {
                Button(role: .close) {
                    self.dismiss()
                }
            } else {
                Button(action: {
                    self.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                }
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
