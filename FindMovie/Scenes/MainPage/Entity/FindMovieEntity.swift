//
//  FindMovieEntity.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

struct FindMovieEntity: Decodable {
    var search: [SearchEntity]
    var totalResults: Int
}

struct SearchEntity: Decodable, Hashable {
    var title, year: String
    var poster: String
}
