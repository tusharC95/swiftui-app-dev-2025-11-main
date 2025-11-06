//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Michael Gauthier on 2025-10-31.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    /// View model managing video list and selection
    @StateObject private var videoManager = VideoManager()
    
    /// Current playback state
    @State private var isPlaying = false
    
    /// Controls visibility state
    @State private var showControls = true
    
    /// Timer for auto-hiding controls
    @State private var hideControlsTimer: Timer?
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            if videoManager.isLoading {
                // Loading state
                loadingView
            } else if let errorMessage = videoManager.errorMessage {
                // Error state
                errorView(message: errorMessage)
            } else if let currentVideo = videoManager.currentVideo {
                // Main content
                VStack(spacing: 0) {
                    // Title at the top
                    titleHeader
                    
                    // Video player with controls
                    videoPlayerSection(for: currentVideo)
                    
                    // Video details
                    videoDetailsSection(for: currentVideo)
                }
            } else {
                // Empty state
                emptyStateView
            }
        }
    }
    
    // MARK: - View Components
    
    /// Video player section with overlay controls
    private func videoPlayerSection(for video: Video) -> some View {
        ZStack {
            VideoPlayerView(
                videoURL: URL(string: video.hlsURL),
                isPlaying: $isPlaying
            )
            .frame(height: 250)
            
            // Overlay controls - vertically centered
            if showControls {
                MediaControlsView(
                    isPlaying: $isPlaying,
                    canGoPrevious: videoManager.canGoPrevious,
                    canGoNext: videoManager.canGoNext,
                    onPrevious: {
                        isPlaying = false
                        videoManager.previousVideo()
                        showControls = true
                        resetHideControlsTimer()
                    },
                    onNext: {
                        isPlaying = false
                        videoManager.nextVideo()
                        showControls = true
                        resetHideControlsTimer()
                    }
                )
                .onChange(of: isPlaying) { playing in
                    if playing {
                        resetHideControlsTimer()
                    }
                }
                .transition(.opacity)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls.toggle()
            }
            if showControls {
                resetHideControlsTimer()
            }
        }
        .onAppear {
            resetHideControlsTimer()
        }
    }
    
    /// Title header at the top
    private var titleHeader: some View {
        Text("Video Player")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
    }
    
    /// Video details section at the bottom
    private func videoDetailsSection(for video: Video) -> some View {
        VideoDetailsView(video: video)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Timer Methods
    
    /// Resets the auto-hide timer for controls
    private func resetHideControlsTimer() {
        hideControlsTimer?.invalidate()
        hideControlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls = false
            }
        }
    }
    
    /// Loading view
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading videos...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Error view
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                videoManager.retry()
            }
            .buttonStyle(.bordered)
            .tint(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    /// Empty state view
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "video.slash")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No Videos Available")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("There are no videos to display at this time.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ContentView()
}
