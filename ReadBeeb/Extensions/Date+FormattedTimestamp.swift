//
//  Date+FormattedTimestamp.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

extension Date {
    var formattedTimestamp: String {
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        if self < lastWeek {
            return self.formatted(date: .abbreviated, time: .omitted)
        } else {
            return self.formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
        }
    }
}
