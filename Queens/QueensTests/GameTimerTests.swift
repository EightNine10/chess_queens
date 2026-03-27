//
//  GameTimerTests.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-26.
//

import XCTest
@testable import Queens

@MainActor
final class GameTimerTests: XCTestCase {

    // Tests that a new timer starts at 0 seconds.
    func testInitialElapsedSecondsIsZero() {
        let gameTimer = GameTimer()

        XCTAssertEqual(gameTimer.elapsedSeconds, 0)
    }

    // Tests that reset clears elapsed time back to 0.
    func testResetClearsElapsedSeconds() async {
        let gameTimer = GameTimer()

        gameTimer.start()
        try? await Task.sleep(for: .milliseconds(1100))
        gameTimer.reset()

        XCTAssertEqual(gameTimer.elapsedSeconds, 0)
    }

    // Tests that restart clears elapsed time and starts counting again.
    func testRestartResetsAndStartsAgain() async {
        let gameTimer = GameTimer()

        gameTimer.start()
        try? await Task.sleep(for: .milliseconds(1100))
        gameTimer.restart()

        XCTAssertEqual(gameTimer.elapsedSeconds, 0)

        try? await Task.sleep(for: .milliseconds(1100))

        XCTAssertGreaterThanOrEqual(gameTimer.elapsedSeconds, 1)
    }

    // Tests that start begins incrementing elapsed time.
    func testStartBeginsCountingTime() async {
        let gameTimer = GameTimer()

        gameTimer.start()
        try? await Task.sleep(for: .milliseconds(1100))

        XCTAssertGreaterThanOrEqual(gameTimer.elapsedSeconds, 1)
    }

    // Tests that stop prevents elapsed time from continuing to increase.
    func testStopPausesElapsedTime() async {
        let gameTimer = GameTimer()

        gameTimer.start()
        try? await Task.sleep(for: .milliseconds(1100))
        gameTimer.stop()

        let stoppedTime = gameTimer.elapsedSeconds

        try? await Task.sleep(for: .milliseconds(1100))

        XCTAssertEqual(gameTimer.elapsedSeconds, stoppedTime)
    }

    // Tests that starting again after stopping resumes from the previous elapsed time.
    func testStartAfterStopResumesFromPreviousElapsedTime() async {
        let gameTimer = GameTimer()

        gameTimer.start()
        try? await Task.sleep(for: .milliseconds(1100))
        gameTimer.stop()

        let stoppedTime = gameTimer.elapsedSeconds

        gameTimer.start()
        try? await Task.sleep(for: .milliseconds(1100))

        XCTAssertGreaterThanOrEqual(gameTimer.elapsedSeconds, stoppedTime + 1)
    }

    // Tests that calling stop before start is harmless.
    func testStopBeforeStartDoesNothing() {
        let gameTimer = GameTimer()

        gameTimer.stop()

        XCTAssertEqual(gameTimer.elapsedSeconds, 0)
    }

    // Tests that calling reset before start is harmless.
    func testResetBeforeStartDoesNothing() {
        let gameTimer = GameTimer()

        gameTimer.reset()

        XCTAssertEqual(gameTimer.elapsedSeconds, 0)
    }
}
