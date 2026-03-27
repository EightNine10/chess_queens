//
//  WinPopupView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-26.
//

import SwiftUI

// View to display end of level times and option buttons
struct WinPopupView: View {

	let yourTime: Int
	let previousBestTime: Int
	let onTryAgain: () -> Void
	let onMainMenu: () -> Void

	var isNewRecord: Bool {
		previousBestTime == 0 || yourTime < previousBestTime
	}

	var bestTime: Int {
		isNewRecord ? yourTime : previousBestTime
	}
    
	var body: some View {
        VStack(spacing: 30) {
            
            VStack(spacing: 8) {
                Text("You Win!")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.appFont)

                Text("Your time: \(String.formattedBestTime(seconds: yourTime))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appFont)
                    
                Text("Best time: \(String.formattedBestTime(seconds: bestTime))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appFont)
                    
                if isNewRecord {
                    Text("New Record!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appLogoColor)
                        .padding(.top, 4)
                }
            }
            
            VStack(spacing: 20) {
                Button(action: onTryAgain) {
                    Text("Try Again")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appFont)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color.lightSquareColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
                
                Button(action: onMainMenu) {
                    Text("Main Menu")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appFont)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color.darkSquareColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 18)
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white, lineWidth: 3)
        )
        .overlay(alignment: .topLeading) {
            Image(systemName: "sparkles")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.appLogoColor)
                .padding(.top, 16)
                .padding(.leading, 16)
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "sparkles")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.appLogoColor)
                .padding(.top, 16)
                .padding(.trailing, 16)
        }
    }
}
