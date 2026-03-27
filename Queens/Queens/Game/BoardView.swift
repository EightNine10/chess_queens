//
//  BoardView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-24.
//

import SwiftUI

// View that renders the board area as well as a grid of BoardSquareViews
struct BoardView : View {

    @ObservedObject var viewModel: GameViewModel
    
    // Formula to compute the radius size of squares based on board size

    var squareCornerRadius : CGFloat {
        let multiplicativeFactor = 1.0 - 0.06 * (CGFloat(viewModel.boardSize) - 4.0)
        return 8.0 * multiplicativeFactor
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.boardSize, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.boardSize, id: \.self) { col in
                        
                        let isLightSquare = (row + col).isMultiple(of: 2)
                        let squarePos = SquarePos(row: row, col: col)
                        
                        BoardSquareView(
                            isLightSquare: isLightSquare,
                            cornerRadius: squareCornerRadius,
                            isConflicting: viewModel.isSquareInConflict(at: squarePos),
                            hasQueen: viewModel.hasQueen(at: squarePos),
                            shouldAnimateWin: (viewModel.isGameWon && viewModel.hasQueen(at: squarePos)),
                            onTap: {
                                viewModel.toggleQueen(at: squarePos)
                            }
                        )
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: squareCornerRadius * 2)
                .stroke(Color.white, lineWidth: squareCornerRadius * 0.5)
        )
    }
}
