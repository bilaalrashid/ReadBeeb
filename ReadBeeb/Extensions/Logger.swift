//
//  Logger.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import OSLog

extension Logger {
    private static var subsystem = Constants.bundleIdentifier

    /// Logging related to networking
    static let network = Logger(subsystem: Logger.subsystem, category: "network")

    static func getAllLogEntries() throws -> [OSLogEntryLog] {
        let logStore = try OSLogStore(scope: .currentProcessIdentifier)
        let oneHourAgo = logStore.position(date: Date().addingTimeInterval(-3600))
        let allEntries = try logStore.getEntries(at: oneHourAgo)

        // FB8518539: Using NSPredicate to filter the subsystem doesn't seem to work.
        return allEntries
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.subsystem == subsystem }
    }
}
