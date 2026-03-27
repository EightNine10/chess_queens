//
//  MenuButtonView.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-23.
//

import SwiftUI

// Main Menu Button View displays the board size for a level,
// as well as the user's best time if they have previously completed the level
struct MenuButtonView: View {
    
    let size: Int
    let bestTime: Int?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            ZStack {
                if bestTime != nil {
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .frame(width: 28, alignment: .leading)
                            
                        Spacer()
                            
                        Text(bestTimeString)
                            .font(.subheadline)
                            .frame(width: 64, alignment: .trailing)
                    }
                }

                Text("\(size)x\(size)")
                    .foregroundStyle(Color.appFont)
                    .fontWeight(.bold)
                    .frame(width: 100, alignment: .center)
                
            }
            .foregroundStyle(Color.appFont)
            .padding(.horizontal, 18)
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
    
    var buttonColor: Color {
        return size.isMultiple(of: 2) ? Color.darkSquareColor : Color.lightSquareColor
    }
    
    var bestTimeString: String {
        
        guard let bestTime else {
            return ""
        }
        
        return String.formattedBestTime(seconds: bestTime)
    }
}
