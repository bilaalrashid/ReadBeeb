//
//  JSONDecoderTests.swift
//  ReadBeebTests
//
//  Created by Bilaal Rashid on 23/07/2024.
//

import XCTest
@testable import ReadBeeb

final class JSONDecoderTests: XCTestCase {
    private struct TestContainer: Codable, Equatable {
        let test: String
    }

    func testDecodeWithoutThrowingSuccess() throws {
        let json = #"{"test": "hello"}"#
        // swiftlint:disable:next force_unwrapping
        let result = JSONDecoder().decodeWithoutThrowing(TestContainer.self, from: json.data(using: .utf8)!)
        XCTAssertNoThrow(try result.get())
        XCTAssertEqual(try result.get(), TestContainer(test: "hello"))
    }

    func testDecodeWithoutThrowingFailure() throws {
        let json = #"{"test": 1}"#
        // swiftlint:disable:next force_unwrapping
        let result = JSONDecoder().decodeWithoutThrowing(TestContainer.self, from: json.data(using: .utf8)!)
        XCTAssertThrowsError(try result.get())
    }
}
