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
                ZStack {
                    Circle()
                        .fill(Color(red: 221/255, green: 221/255, blue: 221/255))
                        .frame(width: 60, height: 60)
                    
                    Image("previous")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.black)
                }
            }
            .disabled(!canGoPrevious)
            .opacity(canGoPrevious ? 1.0 : 0.5)
            
            // Play/Pause Button
            Button(action: togglePlayPause) {
                ZStack {
                    Circle()
                        .fill(Color(red: 221/255, green: 221/255, blue: 221/255))
                        .frame(width: 80, height: 80)
                    
                    Image(isPlaying ? "pause" : "play")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .foregroundColor(.black)
                }
            }
            
            // Next Button
            Button(action: onNext) {
                ZStack {
                    Circle()
                        .fill(Color(red: 221/255, green: 221/255, blue: 221/255))
                        .frame(width: 60, height: 60)
                    
                    Image("next")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.black)
                }
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

