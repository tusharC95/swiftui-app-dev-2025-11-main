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
    
    /// Player instance to control playback
    let player: AVPlayer
    
    // MARK: - Initialization
    
    init(videoURL: URL?, isPlaying: Binding<Bool>) {
        self.videoURL = videoURL
        self._isPlaying = isPlaying
        self.player = AVPlayer()
    }
    
    // MARK: - UIViewControllerRepresentable
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false // Use custom controls
        
        // Set up player with video URL if available
        if let url = videoURL {
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
        }
        
        // Ensure video is paused on initial load
        player.pause()
        
        // Add observer for player state changes
        context.coordinator.addObservers(to: player)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update player item if URL changes
        if let url = videoURL,
           player.currentItem?.asset as? AVURLAsset != AVURLAsset(url: url) {
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            // Reset to paused state when video changes
            player.pause()
            DispatchQueue.main.async {
                isPlaying = false
            }
        }
        
        // Update playback state based on isPlaying binding
        if isPlaying {
            if player.rate == 0 {
                player.play()
            }
        } else {
            if player.rate != 0 {
                player.pause()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject {
        var parent: VideoPlayerView
        private var timeObserver: Any?
        private var statusObserver: NSKeyValueObservation?
        
        init(_ parent: VideoPlayerView) {
            self.parent = parent
        }
        
        /// Adds observers to monitor player state
        func addObservers(to player: AVPlayer) {
            // Observe player status
            statusObserver = player.observe(\.timeControlStatus, options: [.new]) { [weak self] player, _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // Update isPlaying based on actual player state
                    switch player.timeControlStatus {
                    case .playing:
                        self.parent.isPlaying = true
                    case .paused:
                        self.parent.isPlaying = false
                    case .waitingToPlayAtSpecifiedRate:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        }
        
        /// Removes all observers when view is deallocated
        deinit {
            statusObserver?.invalidate()
            if let observer = timeObserver {
                parent.player.removeTimeObserver(observer)
            }
        }
    }
    
    // MARK: - Static Methods
    
    /// Dismantles the view controller and cleans up resources
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        uiViewController.player?.pause()
        uiViewController.player = nil
    }
}

