//
//  GameTimerView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-25.
//

import SwiftUI

// View that displays the State of the GameTimer as a Text view
struct GameTimerView: View {
    @ObservedObject var gameTimer: GameTimer

    var body: some View {
        Text(String.formattedBestTime(seconds: gameTimer.elapsedSeconds))
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(Color.appFont)
            .monospacedDigit()
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.appBackground)
            )
    }
}
