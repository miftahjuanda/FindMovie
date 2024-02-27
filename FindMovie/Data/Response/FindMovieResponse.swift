//
//  FindMovieResponse.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

// MARK: - FindMovieResponse
struct FindMovieResponse: Codable {
    var search: [Search]?
    var totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable {
    var title, year, imdbID: String?
    var type: String?
    var poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
