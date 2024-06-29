//
//  LogScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI
import OSLog
import UniformTypeIdentifiers

/// The screen that displays log messages generated by the system.
struct LogScreen: View {
    /// An action that dismisses the current presentation.
    @Environment(\.dismiss) var dismiss

    /// The view model representing the screen.
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        List {
            Section {
                ForEach(self.viewModel.logMessages, id: \.self) { entry in
                    Text("[\(entry.level.rawValue)] \(entry.date): \(entry.subsystem) [\(entry.category)]: \(entry.composedMessage)")
                        .font(.caption)
                        .textSelection(.enabled)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Logs")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Constants.primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ShareLink(item: self.viewModel.messagesString)
                .foregroundColor(Constants.primaryColor)
        }
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.logRequest, isEmpty: self.viewModel.isEmpty))
        .onAppear {
            Task {
                self.viewModel.fetchData()
            }
        }
    }
}

#Preview {
    LogScreen()
}
