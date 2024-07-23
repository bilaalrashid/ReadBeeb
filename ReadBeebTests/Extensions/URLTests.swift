//
//  URLTests.swift
//  ReadBeebTests
//
//  Created by Bilaal Rashid on 23/07/2024.
//

import XCTest
@testable import ReadBeeb

final class URLTests: XCTestCase {
    func testIsBbcUrl() throws {
        // swiftlint:disable force_unwrapping
        XCTAssertTrue(URL(string: "https://bbc.co.uk")!.isBbc, "URL on root doman matches")
        XCTAssertTrue(URL(string: "https://bbci.co.uk")!.isBbc, "URL on root doman matches")
        XCTAssertTrue(URL(string: "https://bbc.com")!.isBbc, "URL on root doman matches")

        XCTAssertTrue(URL(string: "https://bbc.co.uk/blah")!.isBbc, "URL with path matches")
        XCTAssertTrue(URL(string: "https://bbci.co.uk/blah")!.isBbc, "URL with path matches")
        XCTAssertTrue(URL(string: "https://bbc.com/blah")!.isBbc, "URL with path matches")

        XCTAssertTrue(URL(string: "https://blah.bbc.co.uk/blah")!.isBbc, "URL on hostname matches")
        XCTAssertTrue(URL(string: "https://blah.bbci.co.uk/blah")!.isBbc, "URL on hostname matches")
        XCTAssertTrue(URL(string: "https://blah.bbc.com/blah")!.isBbc, "URL on hostname matches")

        XCTAssertFalse(URL(string: "https://bilaal.co.uk")!.isBbc, "URL on different domain doesn't hit")
        // swiftlint:enable force_unwrapping
    }

    func testValueOf() throws {
        // swiftlint:disable force_unwrapping
        XCTAssertNil(URL(string: "https://bbc.co.uk")!.valueOf("doesnotexist"), "No parameter returns nil")
        XCTAssertEqual(URL(string: "https://bbc.co.uk?param=1")!.valueOf("param"), "1", "Extracts value of parameter")
        XCTAssertEqual(URL(string: "https://bbc.co.uk?param=1&param=2")!.valueOf("param"), "1", "Extracts first value of parameter")
        // swiftlint:enable force_unwrapping
    }
}
