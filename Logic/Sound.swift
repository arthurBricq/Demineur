import UIKit
import AVFoundation

/// Variable qui joue la musique.
var musicPlayer: AVAudioPlayer?

/// Cette fonction lance une des musiques. 
func playMusic() {
    
    let path = Bundle.main.path(forResource: "song1", ofType:"m4a")!
    let url = URL(fileURLWithPath: path)
    
    do {
        musicPlayer = try AVAudioPlayer(contentsOf: url)
        musicPlayer?.play()
    } catch {
        // couldn't load file :(
    }
    
}
