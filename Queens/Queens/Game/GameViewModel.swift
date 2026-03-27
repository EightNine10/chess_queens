//
//  GameViewModel.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-24.
//

import Foundation
import Combine

struct SquarePos: Hashable {
    let row: Int
    let col: Int
}

// This ViewModel manages the State of the Game including Board Size, Timer, Queens, and Game States
// This class is also responsible for playing sound effects and managing Best Time scores
@MainActor
final class GameViewModel: ObservableObject {
    let boardSize: Int
    let gameTimer: GameTimer
    
    private let bestTimeStore: BestTimeStore
    private let soundPlayer: SoundPlaying

    @Published private(set) var queenSquares: Set<SquarePos> = []
    @Published var isGameWon: Bool = false
    @Published var shouldShowWinPopup: Bool = false
    
    @Published private(set) var finalTime: Int = 0
    @Published private(set) var previousBestTime: Int = 0

    // Main initializer
    init(boardSize: Int) {
        self.boardSize = boardSize
        self.gameTimer = GameTimer()
        self.bestTimeStore = UserDefaultsBestTimeStore()
        self.soundPlayer = SoundManager.shared
    }
    
    // Unit test initializer
    init(boardSize: Int, bestTimeStore: BestTimeStore, soundPlayer: SoundPlaying) {
        self.boardSize = boardSize
        self.gameTimer = GameTimer()
        self.bestTimeStore = bestTimeStore
        self.soundPlayer = soundPlayer
    }

    // These methods update the status of queenSquares which stores a Set of square positions containing Queens
    func hasQueen(at square: SquarePos) -> Bool {
        queenSquares.contains(square)
    }
    
    func numCorrectQueens() -> Int {
        queenSquares.filter {
            !isSquareInConflict(at: $0)
        }.count
    }
    
    func setQueen(_ hasQueen: Bool, at square: SquarePos) {
		if hasQueen {
			queenSquares.insert(square)
		} else {
			queenSquares.remove(square)
		}
	}

	func toggleQueen(at square: SquarePos) {
		
        guard !isGameWon else {
            return
        }
  
        if (hasQueen(at: square)) {
            setQueen(false, at: square)
            soundPlayer.play(.pop)
        } else {
            setQueen(true, at: square)
            soundPlayer.play(isSquareInConflict(at: square) ? .mistake : .queen)
        }
        
        checkForWin()
	}
 
    func resetQueens() {
		queenSquares.removeAll()
		shouldShowWinPopup = false
		isGameWon = false
  
  		finalTime = 0
		previousBestTime = 0
        
		soundPlayer.play(.pop)
		gameTimer.restart()
    }
    
    // Move to Win State if the user has placed Queens correctly
    private func checkForWin() {
        if !isGameWon && numCorrectQueens() == boardSize {
            handleWin()
        }
    }

    // Handle Win State and play sounds/ update animation states
	private func handleWin() {
		isGameWon = true
		gameTimer.stop()
  
        finalTime = gameTimer.elapsedSeconds
        previousBestTime = bestTimeStore.bestTime(for: boardSize)
		storeBestTimeIfNeeded()

		Task { @MainActor in
			try? await Task.sleep(for: .milliseconds(360))

			soundPlayer.play(.win)

			try? await Task.sleep(for: .milliseconds(860))
			shouldShowWinPopup = true
		}
	}

    // Track Best Time data
	private func storeBestTimeIfNeeded() {
        if previousBestTime == 0 || finalTime < previousBestTime {
            bestTimeStore.setBestTime(finalTime, for: boardSize)
        }
	}
 
    // Determine if this square lies on a line between two conflicting Queens (including the squares with Queens)
    func isSquareInConflict(at square: SquarePos) -> Bool {
        let conflictingPairs = queenSquares.flatMap { squareA in
            queenSquares.compactMap { squareB -> (SquarePos, SquarePos)? in
                if squareA == squareB {
                    return nil
                }

                if squareA.row > squareB.row {
                    return nil
                }

                if squareA.row == squareB.row && squareA.col >= squareB.col {
                    return nil
                }

                return squaresConflict(squareA, squareB) ? (squareA, squareB) : nil
            }
        }

        for (squareA, squareB) in conflictingPairs {
            if square == squareA || square == squareB {
                return true
            }

            if isSquare(square, onLineBetween: squareA, and: squareB) {
                return true
            }
        }

        return false
    }
    
    // Helper method to determine if a square lies on the line between two squares
    private func isSquare(_ square: SquarePos, onLineBetween squareA: SquarePos, and squareB: SquarePos) -> Bool {
        let rowDelta = squareB.row - squareA.row
        let colDelta = squareB.col - squareA.col

        let rowStep = rowDelta == 0 ? 0 : rowDelta / abs(rowDelta)
        let colStep = colDelta == 0 ? 0 : colDelta / abs(colDelta)

        if rowDelta != 0 && colDelta != 0 && abs(rowDelta) != abs(colDelta) {
            return false
        }

        var currentRow = squareA.row
        var currentCol = squareA.col

        while true {
            if square.row == currentRow && square.col == currentCol {
                return true
            }

            if currentRow == squareB.row && currentCol == squareB.col {
                break
            }

            currentRow += rowStep
            currentCol += colStep
        }

        return false
    }
    
    // Helper method to determine if two squares are in the same row, column, or diagonal
    private func squaresConflict(_ squarePosA: SquarePos, _ squarePosB: SquarePos) -> Bool {
        if squarePosA == squarePosB {
            return false
        }
        
        let sameRow = squarePosA.row == squarePosB.row
        let sameCol = squarePosA.col == squarePosB.col
        let sameDiagonal = abs(squarePosA.row - squarePosB.row) == abs(squarePosA.col - squarePosB.col)

        return sameRow || sameCol || sameDiagonal
    }

    deinit {
    }
}
