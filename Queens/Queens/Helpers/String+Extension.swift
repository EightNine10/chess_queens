//
//  String+Extension.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-25.
//

import Foundation

extension String {

    // String to Time Formatter
    static func formattedBestTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60

        return "\(minutes):" + String(format: "%02d", seconds)
    }
}
