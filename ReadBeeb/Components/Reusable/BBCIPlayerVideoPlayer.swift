//
//  BBCIPlayerVideoPlayer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import SwiftUI
import AVKit
import OSLog

/// A view that displays a video player.
struct BBCIPlayerVideoPlayer: View {
    /// The video player being played.
    private let player: AVPlayer

    /// Has the user requested that the media item should be played.
    @Binding var shouldPlay: Bool

    init(url: String, shouldPlay: Binding<Bool>) {
        self.player = AVPlayer(url: URL(string: url)!)
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
    BBCIPlayerVideoPlayer(url: "", shouldPlay: Binding.constant(true))
}
