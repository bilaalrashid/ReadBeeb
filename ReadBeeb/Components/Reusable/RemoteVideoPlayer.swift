//
//  RemoteVideoPlayer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import SwiftUI
import AVKit
import OSLog

/// A view that providers a video player for a video located remotely on a network.
struct RemoteVideoPlayer: View {
    /// The video player being played.
    private let player: AVPlayer

    /// Has the user requested that the media item should be played.
    @Binding var shouldPlay: Bool
    
    /// Creates a new view to play a remote video.
    ///
    /// - Parameters:
    ///   - url: The URL that the video is located at.
    ///   - shouldPlay: If the video should be playing.
    init(url: URL, shouldPlay: Binding<Bool>) {
        self.player = AVPlayer(url: url)
        self.player.play()
        self._shouldPlay = shouldPlay
    }

    var body: some View {
        // Use a custom wrapper over `AVVideoPlayer` as the SwiftUI `VideoPlayer` doesn't include a full screen toggle
        VideoPlayer(player: self.player) {
            // Stop showing video player once finished
            self.shouldPlay = false
        }
        .onDisappear {
            self.player.pause()
            self.shouldPlay = false
        }
    }
}

#Preview {
    // swiftlint:disable:next force_unwrapping
    RemoteVideoPlayer(url: URL(string: "https://example.com")!, shouldPlay: Binding.constant(true))
}
