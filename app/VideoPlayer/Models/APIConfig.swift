//
//  APIConfig.swift
//  VideoPlayer
//
//  Configuration constants for API endpoints
//

import Foundation

/// Configuration for API endpoints and base URLs
enum APIConfig {
    /// Base URL for the video API server
    static let baseURL = "http://localhost:4000"
    
    /// Endpoint for fetching the list of videos
    static let videosEndpoint = "\(baseURL)/videos"
}

