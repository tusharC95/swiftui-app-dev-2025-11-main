//
//  MediaControlsView.swift
//  VideoPlayer
//
//  Custom media control buttons for video playback
//

import SwiftUI

/// Custom media control buttons for video player
struct MediaControlsView: View {
    
    // MARK: - Properties
    
    /// Whether the video is currently playing
    @Binding var isPlaying: Bool
    
    /// Whether the previous button should be enabled
    let canGoPrevious: Bool
    
    /// Whether the next button should be enabled
    let canGoNext: Bool
    
    /// Action to perform when previous button is tapped
    let onPrevious: () -> Void
    
    /// Action to perform when next button is tapped
    let onNext: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 40) {
            // Previous Button
            Button(action: onPrevious) {
                Image("previous")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(canGoPrevious ? .primary : .gray)
            }
            .disabled(!canGoPrevious)
            .opacity(canGoPrevious ? 1.0 : 0.5)
            
            // Play/Pause Button
            Button(action: togglePlayPause) {
                Image(isPlaying ? "pause" : "play")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.primary)
            }
            .scaleEffect(1.1)
            
            // Next Button
            Button(action: onNext) {
                Image("next")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(canGoNext ? .primary : .gray)
            }
            .disabled(!canGoNext)
            .opacity(canGoNext ? 1.0 : 0.5)
        }
        .padding()
    }
    
    // MARK: - Private Methods
    
    /// Toggles the play/pause state
    private func togglePlayPause() {
        isPlaying.toggle()
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        // All buttons enabled, playing
        MediaControlsView(
            isPlaying: .constant(true),
            canGoPrevious: true,
            canGoNext: true,
            onPrevious: { print("Previous") },
            onNext: { print("Next") }
        )
        
        // All buttons enabled, paused
        MediaControlsView(
            isPlaying: .constant(false),
            canGoPrevious: true,
            canGoNext: true,
            onPrevious: { print("Previous") },
            onNext: { print("Next") }
        )
        
        // At start of list (previous disabled)
        MediaControlsView(
            isPlaying: .constant(false),
            canGoPrevious: false,
            canGoNext: true,
            onPrevious: { print("Previous") },
            onNext: { print("Next") }
        )
        
        // At end of list (next disabled)
        MediaControlsView(
            isPlaying: .constant(false),
            canGoPrevious: true,
            canGoNext: false,
            onPrevious: { print("Previous") },
            onNext: { print("Next") }
        )
    }
    .padding()
}

