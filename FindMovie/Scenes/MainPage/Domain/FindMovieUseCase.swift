//
//  FindMovieUseCase.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Combine

protocol FindMovieUseCaseProtocol {
    func findMovie(keyword: String, page: Int) -> AnyPublisher<FindMovieEntity, RequestError>
}

internal final class FindMovieUseCase: FindMovieUseCaseProtocol {
    private let networking: HTTPClient
    
    init(networking: HTTPClient = AlamofireHttpClient())  {
        self.networking = networking
    }
    
    func findMovie(keyword: String, page: Int) -> AnyPublisher<FindMovieEntity, RequestError> {
        let request = networking.request(url: FindMovieRequest(keyword: keyword, page: page))
        return request
    }
}
