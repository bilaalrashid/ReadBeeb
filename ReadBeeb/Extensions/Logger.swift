//
//  Logger.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 27/08/2023.
//

import OSLog

extension Logger {
    /// The subsystem of the logger.
    private static let subsystem = Constants.bundleIdentifier

    /// Logging related to networking
    static let network = Logger(subsystem: Logger.subsystem, category: "network")

    /// Returns all log entries for this subsystem.
    static func getAllLogEntries() throws -> [OSLogEntryLog] {
        let logStore = try OSLogStore(scope: .currentProcessIdentifier)
        let oneHourAgo = logStore.position(date: Date().addingTimeInterval(-3600))
        let allEntries = try logStore.getEntries(at: oneHourAgo)

        // FB8518539: Using NSPredicate to filter the subsystem doesn't seem to work.
        return allEntries
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.subsystem == Logger.subsystem }
    }
}
