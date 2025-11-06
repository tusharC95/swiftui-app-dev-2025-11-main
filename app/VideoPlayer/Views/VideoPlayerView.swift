//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  SwiftUI wrapper for AVPlayer to play HLS video streams
//

import SwiftUI
import AVKit
import AVFoundation

/// SwiftUI view that wraps AVPlayerViewController for video playback
struct VideoPlayerView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    
    /// The URL of the video to play (HLS stream)
    let videoURL: URL?
    
    /// Binding to control play/pause state
    @Binding var isPlaying: Bool
    
    // MARK: - UIViewControllerRepresentable
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = context.coordinator.player
        controller.showsPlaybackControls = false // Use custom controls
        
        // Set up player with video URL if available
        if let url = videoURL {
            let playerItem = AVPlayerItem(url: url)
            context.coordinator.player.replaceCurrentItem(with: playerItem)
        }
        
        // Ensure video is paused on initial load
        context.coordinator.player.pause()
        
        // Add observer for player state changes
        context.coordinator.setupObservers()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        let player = context.coordinator.player
        
        // Update player item if URL changes
        if let url = videoURL {
            let currentURL = (player.currentItem?.asset as? AVURLAsset)?.url
            if currentURL != url {
                let playerItem = AVPlayerItem(url: url)
                player.replaceCurrentItem(with: playerItem)
                // Reset to paused state when video changes
                player.pause()
                DispatchQueue.main.async {
                    isPlaying = false
                }
            }
        }
        
        // Update playback state based on isPlaying binding
        if isPlaying {
            if player.rate == 0 && player.currentItem != nil {
                player.play()
            }
        } else {
            if player.rate != 0 {
                player.pause()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPlaying: $isPlaying)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject {
        let player: AVPlayer
        var isPlaying: Binding<Bool>
        private var statusObserver: NSKeyValueObservation?
        
        init(isPlaying: Binding<Bool>) {
            self.player = AVPlayer()
            self.isPlaying = isPlaying
            super.init()
        }
        
        /// Sets up observers to monitor player state
        func setupObservers() {
            // Observe player status
            statusObserver = player.observe(\.timeControlStatus, options: [.new]) { [weak self] player, _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // Update isPlaying based on actual player state
                    switch player.timeControlStatus {
                    case .playing:
                        self.isPlaying.wrappedValue = true
                    case .paused:
                        self.isPlaying.wrappedValue = false
                    case .waitingToPlayAtSpecifiedRate:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        }
        
        /// Removes all observers when coordinator is deallocated
        deinit {
            statusObserver?.invalidate()
            player.pause()
            player.replaceCurrentItem(with: nil)
        }
    }
    
    // MARK: - Static Methods
    
    /// Dismantles the view controller and cleans up resources
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        coordinator.player.pause()
    }
}

