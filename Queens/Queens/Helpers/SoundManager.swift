//
//  SoundManager.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-25.
//

import AVFoundation

enum SoundEffect: String, CaseIterable {
    case queen = "queen"
    case pop = "pop"
    case mistake = "mistake"
    case win = "win"
}

protocol SoundPlaying {
    func play(_ sound: SoundEffect)
}

// Singleton class to play sound effects
// Confroms to a protocol to allow a Mock instance for Unit Testing
@MainActor
final class SoundManager : SoundPlaying {
    static let shared = SoundManager()
    private var players: [SoundEffect: AVAudioPlayer] = [:]
    
    private init() {
        preloadSounds()
    }
    
    private func preloadSounds() {
        
        for sound in SoundEffect.allCases {
            
            guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else {
                continue
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.volume = 0.35
                players[sound] = player
            } catch {
                print("Failed to load sound: \(sound.rawValue)")
            }
        }
    }
    
    func play(_ sound: SoundEffect) {
        guard let player = players[sound] else {
            return
        }
        
        player.currentTime = 0
        player.play()
    }
}
