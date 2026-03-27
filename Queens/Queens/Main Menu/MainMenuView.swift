//
//  MainMenuView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-23.
//

import SwiftUI

// Main Menu view, shows Menu Buttons for grid sizes from 4 to 12
struct MainMenuView: View {

    let bestTimeStore: BestTimeStore
    
    @State private var selectedSize: Int?
    @State private var bestTimes: [Int: Int] = [:]
    
    private let boardSizes = (4...12)

    init(bestTimeStore: BestTimeStore = UserDefaultsBestTimeStore()) {
        self.bestTimeStore = bestTimeStore
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                        .frame(height: 40)
                        
                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(Color.appLogoColor)
                        
                        Text("Choose a board size")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.appFont)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        ForEach(boardSizes, id: \.self) { size in
                            MenuButtonView(size: size, bestTime: bestTimes[size]) {
                                selectedSize = size
                            }
                            .padding(.horizontal, 60)
                        }
                    }
                    .padding(.vertical, 30)
                }
            }
            .navigationTitle("Queens Puzzle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedSize) { size in
                GameView(boardSize: size)
            }
            .onAppear() {
                _ = SoundManager.shared // Preload sounds if necessary
                loadBestTimes()
            }
        }
    }
    
    private func loadBestTimes() {
        bestTimes = Dictionary(uniqueKeysWithValues: boardSizes.compactMap { size in
            let bestTime = bestTimeStore.bestTime(for: size)
            return bestTime > 0 ? (size, bestTime) : nil
        })
    }
}
