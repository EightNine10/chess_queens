//
//  BestTimeStore.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-26.
//

import Foundation

// Protocol to allow both real access to UserDefaults (using UserDefaultsBestTimeStore,
// as well as a Mock instance for Unit testing
protocol BestTimeStore {
    func bestTime(for boardSize: Int) -> Int
    func setBestTime(_ time: Int, for boardSize: Int)
}

final class UserDefaultsBestTimeStore: BestTimeStore {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func bestTime(for boardSize: Int) -> Int {
        userDefaults.integer(forKey: key(for: boardSize))
    }

    func setBestTime(_ time: Int, for boardSize: Int) {
        userDefaults.set(time, forKey: key(for: boardSize))
    }

    private func key(for boardSize: Int) -> String {
        "best_time_\(boardSize)"
    }
}
