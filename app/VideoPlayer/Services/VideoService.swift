//
//  VideoService.swift
//  VideoPlayer
//
//  Service for fetching video data from the API
//

import Foundation

/// Custom errors for video service operations
enum VideoServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .noData:
            return "No data received from server"
        }
    }
}

/// Service class for handling video API requests
class VideoService {
    
    /// Shared singleton instance
    static let shared = VideoService()
    
    /// Private initializer for singleton pattern
    private init() {}
    
    /// Fetches the list of videos from the API
    /// - Returns: Array of Video objects sorted by published date
    /// - Throws: VideoServiceError if the request fails
    func fetchVideos() async throws -> [Video] {
        // Validate URL
        guard let url = URL(string: APIConfig.videosEndpoint) else {
            throw VideoServiceError.invalidURL
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            // Perform network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw VideoServiceError.invalidResponse
            }
            
            // Check if data is not empty
            guard !data.isEmpty else {
                throw VideoServiceError.noData
            }
            
            // Use custom JSON decoder with proper date handling
            let decoder = Video.jsonDecoder
            
            // Decode the JSON response
            let videos = try decoder.decode([Video].self, from: data)
            
            return videos
            
        } catch let error as VideoServiceError {
            // Re-throw custom errors
            throw error
        } catch let decodingError as DecodingError {
            // Handle decoding errors
            throw VideoServiceError.decodingError(decodingError)
        } catch {
            // Handle general network errors
            throw VideoServiceError.networkError(error)
        }
    }
}

