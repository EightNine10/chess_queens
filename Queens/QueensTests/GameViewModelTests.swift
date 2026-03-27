//
//  GameViewModelTests.swift
//  QueensTests
//
//  Created by Peter Rutherford on 2026-03-26.
//

import XCTest
@testable import Queens

final class MockSoundPlayer: SoundPlaying {
    private(set) var playedSounds: [SoundEffect] = []

    func play(_ sound: SoundEffect) {
        playedSounds.append(sound)
    }
    
    func removeAll()
    {   playedSounds.removeAll()
    }
}

final class MockBestTimeStore: BestTimeStore {
    var bestTimes: [Int: Int] = [:]

    func bestTime(for boardSize: Int) -> Int {
        bestTimes[boardSize] ?? 0
    }

    func setBestTime(_ time: Int, for boardSize: Int) {
        bestTimes[boardSize] = time
    }
}

@MainActor
final class GameViewModelTests: XCTestCase {

    // Tests that a new game starts with no queens placed.
    func testStartsWithNoQueens() {
        let viewModel = makeViewModel()

        XCTAssertTrue(viewModel.queenSquares.isEmpty)
    }

    // Tests that setting a queen to true adds it to the board.
    func testSetQueenTrue() {
        let viewModel = makeViewModel()
        let square = SquarePos(row: 0, col: 1)

        viewModel.setQueen(true, at: square)

        XCTAssertTrue(viewModel.hasQueen(at: square))
    }

    // Tests that setting a queen to false removes it from the board.
    func testSetQueenFalse() {
        let viewModel = makeViewModel()
        let square = SquarePos(row: 0, col: 1)

        viewModel.setQueen(true, at: square)
        viewModel.setQueen(false, at: square)

        XCTAssertFalse(viewModel.hasQueen(at: square))
    }

    func test() {
        let _ = makeViewModel()
    }
    
    func testCreateAndHoldViewModel() async throws {
        let viewModel = makeViewModel()

        try await Task.sleep(for: .seconds(8))

        withExtendedLifetime(viewModel) {}
    }
    
    // Tests that toggling an empty square adds a queen.
    func testToggleAddsQueen() {
        let viewModel = makeViewModel()
        let square = SquarePos(row: 0, col: 1)

        viewModel.toggleQueen(at: square)

        XCTAssertTrue(viewModel.hasQueen(at: square))
    }

    // Tests that toggling a square with a queen removes it.
    func testToggleRemovesQueen() {
        let viewModel = makeViewModel()
        let square = SquarePos(row: 0, col: 1)

        viewModel.setQueen(true, at: square)
        viewModel.toggleQueen(at: square)

        XCTAssertFalse(viewModel.hasQueen(at: square))
    }

    // Tests that a single queen is not in conflict.
    func testSingleQueenNotConflicting() {
        let viewModel = makeViewModel()
        let square = SquarePos(row: 0, col: 1)

        viewModel.setQueen(true, at: square)

        XCTAssertFalse(viewModel.isSquareInConflict(at: square))
    }

    // Tests that two queens in the same row are conflicting.
    func testSameRowConflict() {
        let viewModel = makeViewModel()
        let a = SquarePos(row: 0, col: 0)
        let b = SquarePos(row: 0, col: 3)

        viewModel.setQueen(true, at: a)
        viewModel.setQueen(true, at: b)

        XCTAssertTrue(viewModel.isSquareInConflict(at: a))
        XCTAssertTrue(viewModel.isSquareInConflict(at: b))
    }

    // Tests that two queens in the same column are conflicting.
    func testSameColumnConflict() {
        let viewModel = makeViewModel()
        let a = SquarePos(row: 0, col: 2)
        let b = SquarePos(row: 3, col: 2)

        viewModel.setQueen(true, at: a)
        viewModel.setQueen(true, at: b)

        XCTAssertTrue(viewModel.isSquareInConflict(at: a))
        XCTAssertTrue(viewModel.isSquareInConflict(at: b))
    }

    // Tests that two queens on the same diagonal are conflicting.
    func testDiagonalConflict() {
        let viewModel = makeViewModel()
        let a = SquarePos(row: 0, col: 0)
        let b = SquarePos(row: 3, col: 3)

        viewModel.setQueen(true, at: a)
        viewModel.setQueen(true, at: b)

        XCTAssertTrue(viewModel.isSquareInConflict(at: a))
        XCTAssertTrue(viewModel.isSquareInConflict(at: b))
    }

    // Tests that queens with no row, column, or diagonal conflict are valid.
    func testNoConflict() {
        let viewModel = makeViewModel()
        let a = SquarePos(row: 0, col: 1)
        let b = SquarePos(row: 1, col: 3)

        viewModel.setQueen(true, at: a)
        viewModel.setQueen(true, at: b)

        XCTAssertFalse(viewModel.isSquareInConflict(at: a))
        XCTAssertFalse(viewModel.isSquareInConflict(at: b))
    }

    // Tests that only non-conflicting queens are counted as correct.
    func testNumCorrectQueens() {
        let viewModel = makeViewModel()

        viewModel.setQueen(true, at: SquarePos(row: 0, col: 1))
        viewModel.setQueen(true, at: SquarePos(row: 1, col: 3))
        viewModel.setQueen(true, at: SquarePos(row: 2, col: 0))
        viewModel.setQueen(true, at: SquarePos(row: 3, col: 0))

        XCTAssertEqual(viewModel.numCorrectQueens(), 2)
    }

    // Tests that adding a safe queen plays the queen sound.
    func testSafeQueenSound() {
        let soundPlayer = MockSoundPlayer()
        let viewModel = makeViewModel(soundPlayer: soundPlayer)

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))

        XCTAssertEqual(soundPlayer.playedSounds, [.queen])
    }

    // Tests that adding a conflicting queen plays the mistake sound.
    func testConflictingQueenSound() {
        let soundPlayer = MockSoundPlayer()
        let viewModel = makeViewModel(soundPlayer: soundPlayer)

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 0, col: 3))

        XCTAssertEqual(soundPlayer.playedSounds, [.queen, .mistake])
    }

    // Tests that removing a queen plays the pop sound.
    func testRemoveQueenSound() {
        let soundPlayer = MockSoundPlayer()
        let viewModel = makeViewModel(soundPlayer: soundPlayer)
        let square = SquarePos(row: 0, col: 1)

        viewModel.setQueen(true, at: square)
        soundPlayer.removeAll()

        viewModel.toggleQueen(at: square)

        XCTAssertEqual(soundPlayer.playedSounds, [.pop])
    }

    // Tests that resetting the board clears queens and win state.
    func testResetQueens() {
        let viewModel = makeViewModel()

        viewModel.setQueen(true, at: SquarePos(row: 0, col: 1))
        viewModel.setQueen(true, at: SquarePos(row: 1, col: 3))
        viewModel.resetQueens()

        XCTAssertTrue(viewModel.queenSquares.isEmpty)
        XCTAssertFalse(viewModel.isGameWon)
        XCTAssertFalse(viewModel.shouldShowWinPopup)
        XCTAssertEqual(viewModel.finalTime, 0)
        XCTAssertEqual(viewModel.previousBestTime, 0)
    }

    // Tests that a valid 4x4 solution wins the game.
    func testValidSolutionWins() {
        let viewModel = makeViewModel()

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))
        viewModel.toggleQueen(at: SquarePos(row: 1, col: 3))
        viewModel.toggleQueen(at: SquarePos(row: 2, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 3, col: 2))

        XCTAssertTrue(viewModel.isGameWon)
    }
    
    // Tests that solving the board eventually plays the win sound.
    func testWinningPlaysWinSound() async {
        let soundPlayer = MockSoundPlayer()
        let viewModel = makeViewModel(soundPlayer: soundPlayer)

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))
        viewModel.toggleQueen(at: SquarePos(row: 1, col: 3))
        viewModel.toggleQueen(at: SquarePos(row: 2, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 3, col: 2))

        XCTAssertTrue(viewModel.isGameWon)

        try? await Task.sleep(for: .milliseconds(400))

        XCTAssertEqual(soundPlayer.playedSounds.last, .win)
    }

    // Tests that solving the board eventually shows the win popup.
    func testWinningShowsPopupAfterDelay() async {
        let viewModel = makeViewModel()

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))
        viewModel.toggleQueen(at: SquarePos(row: 1, col: 3))
        viewModel.toggleQueen(at: SquarePos(row: 2, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 3, col: 2))

        XCTAssertTrue(viewModel.isGameWon)
        XCTAssertFalse(viewModel.shouldShowWinPopup)

        try? await Task.sleep(for: .milliseconds(2250))

        XCTAssertTrue(viewModel.shouldShowWinPopup)
    }

    // Tests that queens can no longer be toggled after the game is won.
    func testCannotToggleQueensAfterWin() {
        let viewModel = makeViewModel()

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))
        viewModel.toggleQueen(at: SquarePos(row: 1, col: 3))
        viewModel.toggleQueen(at: SquarePos(row: 2, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 3, col: 2))

        XCTAssertTrue(viewModel.isGameWon)

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))

        XCTAssertTrue(viewModel.hasQueen(at: SquarePos(row: 0, col: 1)))
        XCTAssertEqual(viewModel.queenSquares.count, 4)
    }

    // Tests that resetting after a win clears the win state and board state.
    func testResetAfterWinClearsWinState() {
        let viewModel = makeViewModel()

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))
        viewModel.toggleQueen(at: SquarePos(row: 1, col: 3))
        viewModel.toggleQueen(at: SquarePos(row: 2, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 3, col: 2))

        XCTAssertTrue(viewModel.isGameWon)

        viewModel.resetQueens()

        XCTAssertFalse(viewModel.isGameWon)
        XCTAssertFalse(viewModel.shouldShowWinPopup)
        XCTAssertEqual(viewModel.finalTime, 0)
        XCTAssertEqual(viewModel.previousBestTime, 0)
        XCTAssertTrue(viewModel.queenSquares.isEmpty)
    }

    // Tests that winning captures the previous stored best time.
    func testWinningCapturesPreviousBestTime() {
        let bestTimeStore = MockBestTimeStore()
        bestTimeStore.setBestTime(42, for: 4)

        let viewModel = makeViewModel(bestTimeStore: bestTimeStore)

        viewModel.toggleQueen(at: SquarePos(row: 0, col: 1))
        viewModel.toggleQueen(at: SquarePos(row: 1, col: 3))
        viewModel.toggleQueen(at: SquarePos(row: 2, col: 0))
        viewModel.toggleQueen(at: SquarePos(row: 3, col: 2))

        XCTAssertTrue(viewModel.isGameWon)
        XCTAssertEqual(viewModel.previousBestTime, 42)
    }

    // Tests that squares between two conflicting queens are also marked conflicting.
    func testSquareBetweenConflictingQueensIsMarkedConflicting() {
        let viewModel = makeViewModel()

        viewModel.setQueen(true, at: SquarePos(row: 0, col: 0))
        viewModel.setQueen(true, at: SquarePos(row: 0, col: 3))

        XCTAssertTrue(viewModel.isSquareInConflict(at: SquarePos(row: 0, col: 1)))
        XCTAssertTrue(viewModel.isSquareInConflict(at: SquarePos(row: 0, col: 2)))
    }

    // Tests that a solved board counts all queens as correct.
    func testSolvedBoardHasAllCorrectQueens() {
        let viewModel = makeViewModel()

        viewModel.setQueen(true, at: SquarePos(row: 0, col: 1))
        viewModel.setQueen(true, at: SquarePos(row: 1, col: 3))
        viewModel.setQueen(true, at: SquarePos(row: 2, col: 0))
        viewModel.setQueen(true, at: SquarePos(row: 3, col: 2))

        XCTAssertEqual(viewModel.numCorrectQueens(), 4)
    }

    private func makeViewModel(bestTimeStore: MockBestTimeStore = MockBestTimeStore(), soundPlayer: MockSoundPlayer = MockSoundPlayer()) -> GameViewModel {
        GameViewModel(boardSize: 4, bestTimeStore: bestTimeStore, soundPlayer: soundPlayer)
    }
}
