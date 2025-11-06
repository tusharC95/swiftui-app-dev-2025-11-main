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
                videoPlayerSection(for: currentVideo)
                mediaControlsSection
                videoDetailsSection(for: currentVideo)
            } else {
                // Empty state
                emptyStateView
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
    
    // MARK: - View Components
    
    /// Video player section at the top
    private func videoPlayerSection(for video: Video) -> some View {
        VideoPlayerView(
            videoURL: URL(string: video.hlsURL),
            isPlaying: $isPlaying
        )
        .frame(height: 250)
        .background(Color.black)
    }
    
    /// Media controls section
    private var mediaControlsSection: some View {
        MediaControlsView(
            isPlaying: $isPlaying,
            canGoPrevious: videoManager.canGoPrevious,
            canGoNext: videoManager.canGoNext,
            onPrevious: {
                isPlaying = false
                videoManager.previousVideo()
            },
            onNext: {
                isPlaying = false
                videoManager.nextVideo()
            }
        )
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
    
    /// Video details section at the bottom
    private func videoDetailsSection(for video: Video) -> some View {
        VideoDetailsView(video: video)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
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
