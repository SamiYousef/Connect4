//
//  SoundPlayer.swift
//  Connect4
//
//  Created by Sami Youssef on 9/28/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import AVFoundation
import UIKit

class SoundPlayer {

    var isPlaying = false
    var player = AVAudioPlayer()

    func coinDropping() {
        playSound(withName: "coinDropping")
    }
    
    func newGame() {
        playSound(withName: "newGame")
    }

    func stopPlaying() {
        guard isPlaying else { return }
        player.stop()
        isPlaying = false
    }

    func playSound(withName name: String) {
        guard let sound = NSDataAsset(name: name) else {
            print("sound not found")
            return
        }

        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
            try player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            player.play()
            isPlaying = true
        } catch {
            print("faild to play sound \n \(error.localizedDescription)")
        }
    }

}
