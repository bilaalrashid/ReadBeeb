//
//  LogScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import SwiftUI
import OSLog
import UniformTypeIdentifiers

struct LogScreen: View {
    @Environment(\.dismiss) var dismiss
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
        .overlay(NetworkRequestStatusOverlay(networkRequest: self.viewModel.networkRequest, isEmpty: self.viewModel.isEmpty))
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
