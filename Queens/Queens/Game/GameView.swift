//
//  GameView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-23.
//

import SwiftUI

// The main View of the Game which displays Timer, Queens Status, Board and instructional Text
struct GameView : View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GameViewModel

    init(boardSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(boardSize: boardSize))
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                
            VStack(spacing: 20) {
                
                // [Number of Queens left] Status Display
                VStack(spacing: -4) {
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color.appLogoColor)
                        
                    Text("\(viewModel.numCorrectQueens()) / \(viewModel.boardSize)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appFont)
                }
                
                // Game Board View
                BoardView(viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                // Instructional Text
                Text("Place \(viewModel.boardSize) Queens on the board so that no two share the same row, column, or diagonal")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
            }
            
            // Game Win Popup View
            if viewModel.shouldShowWinPopup {
				ZStack {
					Color.black.opacity(0.38)
						.ignoresSafeArea()

					WinPopupView(
						yourTime: viewModel.finalTime,
						previousBestTime: viewModel.previousBestTime,
						onTryAgain: {
                            viewModel.resetQueens()
						},
						onMainMenu: {
							dismiss()
						}
					)
                    .padding(.horizontal, 60)
				}
				.transition(.opacity)
			}
        }
        .overlay(alignment: .topTrailing) {
            
            // Game Timer View
            GameTimerView(gameTimer: viewModel.gameTimer)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .navigationTitle("\(viewModel.boardSize)x\(viewModel.boardSize) Board")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                // Retry Button
                Button {
                    if !viewModel.isGameWon {
                        viewModel.resetQueens()
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(.thinMaterial))
                }
            }
        }
        .onAppear() {
            viewModel.resetQueens()
            viewModel.gameTimer.restart()
        }
        .onDisappear() {
            viewModel.gameTimer.stop()
        }
    }
}
