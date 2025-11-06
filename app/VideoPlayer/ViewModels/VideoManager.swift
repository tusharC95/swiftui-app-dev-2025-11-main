//
//  VideoManager.swift
//  VideoPlayer
//
//  View model for managing video list and playback state
//

import Foundation

/// View model that manages the video list and current video selection
@MainActor
class VideoManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var videos: [Video] = []
    @Published private(set) var currentVideo: Video?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    // MARK: - Computed Properties
    
    /// Index of the currently selected video
    var currentIndex: Int? {
        guard let currentVideo = currentVideo else { return nil }
        return videos.firstIndex { $0.id == currentVideo.id }
    }
    
    /// Whether the user can navigate to the previous video
    var canGoPrevious: Bool {
        guard let index = currentIndex else { return false }
        return index > 0
    }
    
    /// Whether the user can navigate to the next video
    var canGoNext: Bool {
        guard let index = currentIndex else { return false }
        return index < videos.count - 1
    }
    
    // MARK: - Initialization
    
    /// Initializes the video manager and loads videos
    init() {
        Task {
            await loadVideos()
        }
    }
    
    // MARK: - Public Methods
    
    /// Loads videos from the API and sorts them by published date
    func loadVideos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch videos from API
            let fetchedVideos = try await VideoService.shared.fetchVideos()
            
            // Sort videos by published date (oldest first)
            videos = fetchedVideos.sorted { $0.publishedAt < $1.publishedAt }
            
            // Select the first video by default
            if let firstVideo = videos.first {
                currentVideo = firstVideo
            }
            
            isLoading = false
            
        } catch {
            errorMessage = "Failed to load videos: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// Selects a video at the specified index
    /// - Parameter index: The index of the video to select
    func selectVideo(at index: Int) {
        guard index >= 0 && index < videos.count else {
            return
        }
        currentVideo = videos[index]
    }
    
    /// Navigates to the next video in the list
    func nextVideo() {
        guard canGoNext, let index = currentIndex else {
            return
        }
        selectVideo(at: index + 1)
    }
    
    /// Navigates to the previous video in the list
    func previousVideo() {
        guard canGoPrevious, let index = currentIndex else {
            return
        }
        selectVideo(at: index - 1)
    }
    
    /// Retries loading videos if initial load failed
    func retry() {
        Task {
            await loadVideos()
        }
    }
}

