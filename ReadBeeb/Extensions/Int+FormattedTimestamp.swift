//
//  Int+FormattedTimestamp.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import Foundation

extension Int {

    var formattedTimestamp: String {
        let date = Date(timeIntervalSince1970: Double(self) / 1000)
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        if date < lastWeek {
            return date.formatted(date: .abbreviated, time: .omitted)
        } else {
            return date.formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
        }
    }

}
