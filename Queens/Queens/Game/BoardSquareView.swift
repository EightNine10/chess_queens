//
//  BoardSquareView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-24.
//

import SwiftUI

// The view for an individual square of the game board
struct BoardSquareView: View {

    let isLightSquare: Bool
    let cornerRadius: CGFloat
    let isConflicting: Bool
    let hasQueen: Bool
    let shouldAnimateWin: Bool

    let onTap: () -> Void
    
    @State private var queenScale: CGFloat = 1.0
    @State private var queenRotation: Double = 0.0
    
    var body: some View {
        Button(action: onTap) {
            GeometryReader { geometry in
                let queenSize = geometry.size.width * 0.64
                
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(squareColor)
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.white, lineWidth: cornerRadius * 0.5)
                        }
                        
                        // Queen image
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: queenSize, height: queenSize)
                            .foregroundStyle(isConflicting ? Color.red : Color.black)
                            .scaleEffect(queenScale)
                            .rotationEffect(.degrees(queenRotation))
                }
            }
            .aspectRatio(1, contentMode: .fit)

        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .onAppear {
            queenScale = hasQueen ? 1.0 : 0.0
            queenRotation = 0.0
        }
        .onChange(of: hasQueen) { _, newValue in
            animateToMatchState(newValue)
        }
        .onChange(of: shouldAnimateWin) { _, newValue in
            if newValue {
                animateWin()
            }
        }
    }
    
    // Determine what color to render the square
    var squareColor: Color {
        if isConflicting {
            return isLightSquare ? Color.lightSquareConflictingColor : Color.darkSquareConflictingColor
        } else {
            return isLightSquare ? Color.lightSquareColor : Color.darkSquareColor
        }
    }

	// Animate the Queen piece in or out after a user taps this square
    private func animateToMatchState(_ hasQueen: Bool) {
		if hasQueen {
			queenScale = 0.0

			withAnimation(.easeOut(duration: 0.1)) {
				queenScale = 1.1
			}

			Task {
				try? await Task.sleep(for: .milliseconds(100))

				withAnimation(.easeInOut(duration: 0.1)) {
					queenScale = 1.0
				}
			}
		} else {
			withAnimation(.easeInOut(duration: 0.1)) {
				queenScale = 0.0
			}
		}
	}
 
    // Animate the Queen piece during level win animation
    private func animateWin() {
		
        Task {

            let animationDelay = isLightSquare ? 0 : 100

			try? await Task.sleep(for: .milliseconds(480 + animationDelay))

            withAnimation(.easeOut(duration: 0.24)) {
                queenScale = 1.5
                queenRotation = 30.0
            }

			try? await Task.sleep(for: .milliseconds(240))

			withAnimation(.easeInOut(duration: 0.24)) {
				queenScale = 1.0
				queenRotation = 0.0
			}
		}
	}
}
