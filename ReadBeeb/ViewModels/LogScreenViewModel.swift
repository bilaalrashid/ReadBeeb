//
//  LogScreenViewModel.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 05/11/2023.
//

import Foundation
import OSLog

extension LogScreen {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var logMessages = [OSLogEntryLog]()
        @Published private(set) var networkRequest = NetworkRequestStatus.notStarted

        var isEmpty: Bool {
            return self.logMessages.isEmpty
        }

        var messagesString: String {
            var string = ""

            self.logMessages.forEach { entry in
                let message = "[\(entry.level.rawValue)] \(entry.date): \(entry.subsystem) [\(entry.category)]: \(entry.composedMessage)"
                string += message + "\n"
            }

            return string
        }

        func fetchDataIfNotExists() {
            // We don't want to start another network request if there is already one ongoing
            if self.networkRequest != .loading && self.isEmpty {
                self.fetchData()
            }
        }

        func fetchData() {
            do {
                self.networkRequest = .loading
                let result = try Logger.getAllLogEntries()
                self.logMessages = result
                self.networkRequest = .success
            } catch let error {
                self.networkRequest = .error
                Logger.network.error("Unable to fetch logs - \(error.localizedDescription)")
            }
        }
    }
}
