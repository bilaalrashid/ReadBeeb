//
//  LogScreenViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import Foundation
import OSLog

extension LogScreen {
    /// The view model for the log screen.
    @MainActor class ViewModel: ObservableObject {
        /// The log messages generated by the system.
        @Published private(set) var logMessages = [OSLogEntryLog]()

        /// The status of the request to fetch the log messages.
        @Published private(set) var logRequest = NetworkRequestStatus.notStarted

        /// If there aren't any log messages.
        var isEmpty: Bool {
            return self.logMessages.isEmpty
        }

        /// The log messages formatted for display, as a single string object.
        ///
        /// Each log message is included on a separate line.
        var messagesString: String {
            let formatted = self.logMessages.map { entry in
                "[\(entry.level.rawValue)] \(entry.date): \(entry.subsystem) [\(entry.category)]: \(entry.composedMessage)"
            }

            return formatted.joined(separator: "\n")
        }

        /// Fetch log messages from the log store, if they haven't already been fetched.
        func fetchDataIfNotExists() {
            // We don't want to start another network request if there is already one ongoing
            if self.logRequest != .loading && self.isEmpty {
                self.fetchData()
            }
        }

        /// Fetch log messages from the log store.
        func fetchData() {
            do {
                self.logRequest = .loading
                let result = try Logger.getAllLogEntries()
                self.logMessages = result
                self.logRequest = .success
            } catch let error {
                self.logRequest = .error
                Logger.network.error("Unable to fetch logs - \(error.localizedDescription)")
            }
        }
    }
}
