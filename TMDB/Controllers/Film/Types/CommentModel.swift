//
//  CommentModel.swift
//  TMDB
//
//  Created by Murat Akdal on 23.05.2023.
//

import Foundation

struct Review: Codable {
    var stars: Int
    var comment: String
    var userEmail: String

    init(stars: Int, comment: String, userEmail: String) {
        self.stars = stars
        self.comment = comment
        self.userEmail = userEmail
    }
    
}

struct ReviewList: Codable {
    var results: [Review]
}
