//
//  GameTimer.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-25.
//

import Foundation
import Combine

// Object that manages the timer during gameplay to track the length of the playtime
@MainActor
final class GameTimer: ObservableObject {
    @Published private(set) var elapsedSeconds: Int = 0

    private var timer: Timer?
    private var startDate: Date?

    func start() {
        guard timer == nil else {
            return
        }

        startDate = Date().addingTimeInterval(-TimeInterval(elapsedSeconds))

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let weakSelf = self else {
                return
            }

            Task { @MainActor [weak weakSelf] in
                guard let self = weakSelf, let startDate = self.startDate else {
                    return
                }

                self.elapsedSeconds = Int(Date().timeIntervalSince(startDate))
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stop()
        elapsedSeconds = 0
        startDate = nil
    }

    func restart() {
        reset()
        start()
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}
