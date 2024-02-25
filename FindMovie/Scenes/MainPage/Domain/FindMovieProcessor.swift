//
//  FindMovieProcessor.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

protocol FindMovieProcessorProtocol {
    func mapDataToEntity(_ model: FindMovieResponse?) -> FindMovieEntity
}

internal final class FindMovieProcessor: FindMovieProcessorProtocol {
    func mapDataToEntity(_ model: FindMovieResponse?) -> FindMovieEntity {
        let searchEntity = model?.search?.map({
            SearchEntity(title: $0.title ?? "",
                         year: $0.year ?? "",
                         poster: $0.poster ?? "",
                         isLoading: false)
        }) ?? []
        
        let response: Bool = model?.response?.lowercased() == "true" ? true : false
        return FindMovieEntity(search: searchEntity,
                               totalResults: Int(model?.totalResults ?? "") ?? 0, 
                               response: response)
    }
}
