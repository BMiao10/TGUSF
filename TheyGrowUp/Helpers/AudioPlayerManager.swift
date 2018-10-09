// AudioPlayerManager
//
// Copyright (c) 2018 Jared Shenson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public class AudioPlayerManager {
    
    /// Singleton shared instance
    static let shared = AudioPlayerManager()
    
    private var players: [AudioPlayer] = []
    private var _playersToDiscardOnCompletion: [AudioPlayer] = []
    
    private init () {
        NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayerManager.soundDidFinishPlaying(_:)), name: AudioPlayer.SoundDidFinishPlayingNotification, object: nil)
    }
    
    // MARK - Play
    
    /**
        Checks if player exists for specified audio file. If so, resumes play.
        If not, initializes new audioplayer with filename and starts playing
        - parameter fileName: Name of audio file with extension (e.g. "audio.mp3")
        - parameter discardOnCompletion: If true, the AudioPlayer instance will be deleted as soon as the sound completes playing successfully. (Default = true)
        - Throws: AudioPlayerError
        - Returns: Existing or initialized AudioPlayer
    */
    static func play(fileName: String, discardOnCompletion discard: Bool = true) throws -> AudioPlayer {
        if let player = self.playerWith(name: fileName) {
            player.play()
            return player
        } else {
            let player = try AudioPlayer.init(fileName: fileName)
            self.shared.addPlayer( player )
            return player
        }
    }
    
    /**
     Checks if player exists for specified audio file path. If so, resumes play.
     If not, initializes new audioplayer with file path and starts playing
     - parameter path: Path to audio file with extension (e.g. "Assets/audio.mp3")
     - parameter discardOnCompletion: If true, the AudioPlayer instance will be deleted as soon as the sound completes playing successfully. (Default = true)
     - Throws: AudioPlayerError
     - Returns: Existing or initialized AudioPlayer
     */
    static func play(contentsOfPath path: String, discardOnCompletion discard: Bool = true) throws -> AudioPlayer {
        let fileURL = URL(fileURLWithPath: path)
        return try play(contentsOfUrl: fileURL, discardOnCompletion: discard)
    }
    
    /**
     Checks if player exists for specified audio file URL. If so, resumes play.
     If not, initializes new audioplayer with file URL and starts playing
     - parameter url: URL to audio file with extension
     - parameter discardOnCompletion: If true, the AudioPlayer instance will be deleted as soon as the sound completes playing successfully. (Default = true)
     - Throws: AudioPlayerError
     - Returns: Existing or initialized AudioPlayer
     */
    static func play(contentsOfUrl url: URL, discardOnCompletion discard: Bool = true) throws -> AudioPlayer {
        if let player = self.playerWith(name: url.lastPathComponent) {
            player.play()
            return player
        } else {
            let player = try AudioPlayer.init(contentsOf: url)
            self.shared.addPlayer( player )
            return player
        }
    }
    
    /// Resumes play on all players
    static func play() {
        self.shared.players.forEach { (player) in
            player.play()
        }
    }
    
    // MARK - Stop
    
    /// Stop an audioplayer with given name
    static func stop(name: String) {
        if let player = self.playerWith(name: name) {
            player.stop()
        }
    }
    
    /// Stop all players
    static func stop() {
        self.shared.players.forEach { (player) in
            player.stop()
        }
    }
    
    // MARK - Remove
    
    /// Stops playing and removes a given AudioPlayer
    static func remove(player: AudioPlayer) {
        player.stop()
        
        let apm = self.shared
        apm.players.removeAll { (ap) -> Bool in
            return ap == player
        }
        apm._playersToDiscardOnCompletion.removeAll { (ap) -> Bool in
            return ap == player
        }
    }
    
    /// Stops playing and removes an AudioPlayer by name
    static func remove(name: String) {
        if let player = self.playerWith(name: name) {
            remove( player: player )
        }
    }
    
    // MARK - Helpers
    
    /// Retrieve the AudioPlayer with given name
    static func playerWith(name: String) -> AudioPlayer? {
        return self.shared.players.first(where: { (player) -> Bool in
            return player.name == name
        })
    }
    
    private func addPlayer(_ player: AudioPlayer, discardOnCompletion discard: Bool = true ) {
        players.append(player)
        
        if discard {
            _playersToDiscardOnCompletion.append(player)
        }
        
        player.play()
    }
    
    private func hasPlayer(_ player: AudioPlayer) -> Bool {
        return players.contains(player)
    }
    
    private func hasPlayer(_ name: String) -> Bool {
        return players.contains { (player) -> Bool in
            return player.name == name
        }
    }
    
    @objc private func soundDidFinishPlaying(_ notification: Notification) {
        let player = notification.object as! AudioPlayer
        let success = notification.userInfo?[ AudioPlayer.SoundDidFinishPlayingSuccessfully ] as! Bool
        if success && _playersToDiscardOnCompletion.contains(player) {
            AudioPlayerManager.remove( player: player )
        }
    }
    
}
