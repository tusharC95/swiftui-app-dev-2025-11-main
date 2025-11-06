//
//  Video.swift
//  VideoPlayer
//
//  Models representing video data from the API
//

import Foundation

/// Represents an author of a video
struct Author: Codable, Identifiable {
    let id: String
    let name: String
}

/// Represents a video with metadata and streaming URLs
struct Video: Codable, Identifiable {
    let id: String
    let title: String
    let hlsURL: String
    let fullURL: String
    let description: String
    let publishedAt: Date
    let author: Author
    
    /// Custom coding keys to match API response format
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case hlsURL
        case fullURL
        case description
        case publishedAt
        case author
    }
}

/// Extension to provide a custom JSON decoder with proper date handling
extension Video {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

