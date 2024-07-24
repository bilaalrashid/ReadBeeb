//
//  Int+DurationFormattedString.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 20/10/2023.
//

import Foundation

extension Int {
    /// Converts milliseconds to a formatted string describing the time interval.
    var formattedMillisecondsDuration: String? {
        let interval = TimeInterval(self) / 1000

        if interval < 60 {
            return "\(Int(interval))s"
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        return formatter.string(from: interval)
    }
}
