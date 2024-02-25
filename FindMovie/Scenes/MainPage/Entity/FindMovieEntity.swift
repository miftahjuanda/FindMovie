//
//  FindMovieEntity.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

struct FindMovieEntity: Decodable {
    var search: [SearchEntity] = []
    var totalResults: Int = 0
    var response: Bool = false
}

struct SearchEntity: Decodable, Hashable {
    var id = UUID()
    var title: String = ""
    var year: String = ""
    var poster: String = "-"
    var isLoading: Bool = true
}
