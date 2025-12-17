import AVFoundation

final class NatureSoundManager {
    static let shared = NatureSoundManager()
    private var loopPlayer: AVAudioPlayer?
    private var fxPlayer: AVAudioPlayer?

    func playAmbient(for hour: Double) {
        stopAmbient()
        let name: String
        switch hour {
        case 6..<10:  name = "birds_morning.mp3"
        case 10..<17: name = "breeze_wind.mp3"
        case 17..<24: name = "crickets_evening.mp3"
        default:      name = "crickets_evening.mp3"
        }
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
        loopPlayer = try? AVAudioPlayer(contentsOf: url)
        loopPlayer?.numberOfLoops = -1
        loopPlayer?.volume = 0.5
        loopPlayer?.play()
    }

    func stopAmbient() { loopPlayer?.stop() }

    func playFX(_ name: String, volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
        fxPlayer = try? AVAudioPlayer(contentsOf: url)
        fxPlayer?.volume = volume
        fxPlayer?.play()
    }

    func focusEndFX() { playFX("squirrel_tap.mp3", volume: 0.9) }
    func waterFX()    { playFX("water_splash.mp3", volume: 0.8) }
}
