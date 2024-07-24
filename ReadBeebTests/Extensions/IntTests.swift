//
//  IntTests.swift
//  ReadBeebTests
//
//  Created by Bilaal Rashid on 24/07/2024.
//

import XCTest
@testable import ReadBeeb

final class IntTests: XCTestCase {
    func testFormattedMillisecondsDuration() throws {
        XCTAssertEqual(1.formattedMillisecondsDuration, "0s", "Under 1 second becomes 0")
        XCTAssertEqual(1_000.formattedMillisecondsDuration, "1s", "Under 1 minute renders as seconds")
        XCTAssertEqual(61_000.formattedMillisecondsDuration, "1:01", "Renders minutes and seconds")
        XCTAssertEqual(3_661_000.formattedMillisecondsDuration, "1:01:01", "Renders hours, minutes and seconds")
    }
}
