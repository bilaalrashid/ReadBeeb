//
//  VideoPlayer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import Foundation
import SwiftUI
import AVKit

/// A wrapper around `AVPlayerViewController` for SwiftUI
struct VideoPlayer: UIViewControllerRepresentable {
    /// The AVPlayer to play in the view controller
    let player: AVPlayer

    /// The callback to call when the video is finished
    let onFinish: (() -> Void)?

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        viewController.player = self.player
        viewController.canStartPictureInPictureAutomaticallyFromInline = true
        viewController.beginAppearanceTransition(true, animated: false)

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .moviePlayback)

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.onFinish?()
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = self.player

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.onFinish?()
        }
    }

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        uiViewController.beginAppearanceTransition(false, animated: false)
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.soloAmbient)
    }
}
