//
//  Date+FormattedString.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

extension Date {
    /// A human-readable string describing the date, preferring a relative description for dates within the past week.
    var formattedString: String {
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        if self < lastWeek {
            return self.formatted(date: .abbreviated, time: .omitted)
        }

        return self.formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
    }
}
