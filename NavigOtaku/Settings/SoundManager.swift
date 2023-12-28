//
//  SoundManager.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import Foundation
import SwiftUI
import AVFoundation

let filename = "あはは"
let type = "mp3"

class SoundManager: ObservableObject {
    @AppStorage("startupSoundEnabled") var startupSoundEnabled: Bool = true
    
    @Published var audioPlayer: AVAudioPlayer?
    
    func playSound() {
        if startupSoundEnabled {
            if let path = Bundle.main.path(forResource: filename, ofType: type) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    audioPlayer?.play()
                } catch {
                    print("Error file no found")
                }
            }
        }
    }
}
