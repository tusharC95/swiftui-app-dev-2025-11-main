//
//  VideoDetailsView.swift
//  VideoPlayer
//
//  Displays video metadata and description with Markdown rendering
//

import SwiftUI
import MarkdownUI

/// View that displays video title, author, and description
struct VideoDetailsView: View {
    
    // MARK: - Properties
    
    /// The video to display details for
    let video: Video
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(video.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Author
                Text("By \(video.author.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Divider
                Divider()
                    .padding(.vertical, 4)
                
                // Description as Markdown
                Markdown(video.description)
                    .markdownTheme(.gitHub)
                    .padding(.top, 4)
            }
            .padding([.horizontal, .bottom])
        }
    }
}

// MARK: - Preview

#Preview {
    VideoDetailsView(
        video: Video(
            id: "1",
            title: "Sample Video Title",
            hlsURL: "https://example.com/video.m3u8",
            fullURL: "https://example.com/video.mp4",
            description: """
            # Main Heading
            
            ## Subheading
            
            This is a paragraph with **bold text** and *italic text*.
            
            - List item 1
            - List item 2
            - List item 3
            
            1. Numbered item 1
            2. Numbered item 2
            
            [Link example](https://example.com)
            """,
            publishedAt: Date(),
            author: Author(
                id: "1",
                name: "John Doe"
            )
        )
    )
}

