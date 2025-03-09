//
//  fetchQuotes.swift
//  Quotes
//
//  Created by Tiffany Luu on 3/8/25.
//

import Foundation

struct Quote: Decodable {
    let text: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case author = "author"
    }
}

func fetchRandomQuote() async throws -> Quote {
    // Construct URL
    guard let url = URL(string: "https://thequoteshub.com/api/random-quote") else {
        throw URLError(.badURL)
    }
    
    // Fetch data from API
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Check if response is valid
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    // Decode JSON response into Quote object
    let quote = try JSONDecoder().decode(Quote.self, from: data)
    return quote
}

