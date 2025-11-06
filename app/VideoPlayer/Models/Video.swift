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
        
        // Custom date formatter to handle ISO8601 with milliseconds
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        
        return decoder
    }
}

