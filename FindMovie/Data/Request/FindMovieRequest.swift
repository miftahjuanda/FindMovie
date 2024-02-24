//
//  FindMovieRequest.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

internal struct FindMovieRequest: RestApi {
    typealias Response = FindMovieEntity
    
    private let processor = FindMovieProcessor()
    var baseURL: String = ApiConfigManager.shared.getBaseUrl()
    var path: String = "/"
    var headers: [String : String]? = [:]
    var queryItems: [URLQueryItem]?
    
    init(keyword: String, page: Int) {
        queryItems = [
            .init(name: "s", value: keyword),
            .init(name: "page", value: String(page)),
            .init(name: "apikey", value: ApiConfigManager.shared.getApiKey())]
    }
    
    func map(_ data: Data) throws -> FindMovieEntity {
        let data = try JSONDecoder().decode(FindMovieResponse.self, from: data)
        let processor = processor.mapDataToEntity(data)
        
        return processor
    }
}

