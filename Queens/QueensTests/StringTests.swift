//
//  StringTests.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-26.
//

import XCTest
@testable import Queens

final class StringTests: XCTestCase {

    // Tests that 0 seconds formats as 0:00.
    func testZeroSeconds() {
        let result = String.formattedBestTime(seconds: 0)

        XCTAssertEqual(result, "0:00")
    }

    // Tests that single-digit seconds are zero-padded.
    func testSingleDigitSeconds() {
        let result = String.formattedBestTime(seconds: 5)

        XCTAssertEqual(result, "0:05")
    }

    // Tests that an exact minute formats correctly.
    func testExactMinute() {
        let result = String.formattedBestTime(seconds: 60)

        XCTAssertEqual(result, "1:00")
    }

    // Tests that minutes and seconds format correctly together.
    func testMinutesAndSeconds() {
        let result = String.formattedBestTime(seconds: 125)

        XCTAssertEqual(result, "2:05")
    }
}
