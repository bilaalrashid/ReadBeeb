//
//  BBCIPlayerVideoPlayer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import SwiftUI
import AVKit
import OSLog

struct BBCIPlayerVideoPlayer: View {

    private let player: AVPlayer!

    @Binding var shouldPlay: Bool

    init(url: String, shouldPlay: Binding<Bool>) {
        self.player = AVPlayer(url: URL(string: url)!)
        self.player.play()
        self._shouldPlay = shouldPlay
    }

    var body: some View {
        // Use a custom wrapper over AVVideoPlayer as the SwiftUI VideoPlayer doesn't include a full screen toggle
        VideoPlayer(player: player) {
            // Stop showing video player once finished
            self.shouldPlay = false
        }
    }

}

#Preview {
    BBCIPlayerVideoPlayer(url: "", shouldPlay: Binding.constant(true))
}
