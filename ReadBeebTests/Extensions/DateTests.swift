//
//  DateTests.swift
//  ReadBeebTests
//
//  Created by Bilaal Rashid on 24/07/2024.
//

import XCTest
@testable import ReadBeeb

final class DateTests: XCTestCase {
    func testFormattedString() throws {
        XCTAssertEqual(Date(timeIntervalSinceNow: -1).formattedString, "1 sec ago", "Uses relative description for 1 second")
        XCTAssertEqual(Date(timeIntervalSinceNow: -86_400).formattedString, "1 day ago", "Uses relative description for 1 day")
        XCTAssertEqual(
            Date(timeIntervalSinceNow: -604_800).formattedString.ranges(of: /\d\d \w\w\w \d\d\d\d/).count,
            1,
            "Uses absolute date for 7 days ago"
        )
    }
}
