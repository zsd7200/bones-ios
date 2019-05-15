//
//  AudioManager.swift
//  Bones
//
//  Created by Student on 5/2/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit
import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    
    // create two audio players, one for music, one for shaking sounds
    var bgPlayer = AVAudioPlayer()
    var dicePlayer = AVAudioPlayer()
    
    // create URLs to link the mp3s
    private let bgURL = Bundle.main.url(forResource: "puzzleDreams", withExtension: "mp3")!
    private let diceURL = Bundle.main.url(forResource: "shake", withExtension: "mp3")!
    
    // private initializer
    private init() {
        do {
            // load in background music
            bgPlayer = try AVAudioPlayer(contentsOf: bgURL)
            bgPlayer.numberOfLoops = -1 // loop infinitely
            bgPlayer.prepareToPlay()
        } catch {
            print(error)
        }
        
        // load shake sound
        do {
            dicePlayer = try AVAudioPlayer(contentsOf: diceURL)
            dicePlayer.prepareToPlay()
        } catch {
            print(error)
        }
    
        // play background music
        bgPlayer.play()
    }
}
