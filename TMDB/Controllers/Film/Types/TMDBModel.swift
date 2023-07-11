//
//  TMDBApi.swift
//  TMDB
//
//  Created by Murat Akdal on 5.04.2023.
//

import Foundation

struct Movie: Codable {
    var id: Int?
    var title: String?
    var overview: String?
    var releaseDate: String?
    var posterPath: String?
    var voteAverage: Decimal?
    var backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
    }
}

struct MovieListResponse: Codable {
    var results: [Movie]?
}
