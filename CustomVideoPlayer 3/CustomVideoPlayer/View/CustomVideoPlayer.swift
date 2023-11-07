//
//  CustomVideoPlayer.swift
//  CustomVideoPlayer
//
//  Created by Balaji on 24/04/23.
//

import SwiftUI
import AVKit

/// Custom Video Player
struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
