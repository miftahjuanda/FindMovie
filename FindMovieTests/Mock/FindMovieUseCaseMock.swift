//
//  FindMovieUseCaseMock.swift
//  FindMovieTests
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import Combine
@testable import FindMovie

internal final class FindMovieUseCaseMock: FindMovieUseCaseProtocol {
    private let result: Result<FindMovieEntity, RequestError>

    init(result: Result<FindMovieEntity, RequestError> = .success(FindMovieEntity())) {
        self.result = result
    }

    func findMovie(keyword: String, page: Int) -> AnyPublisher<FindMovieEntity, RequestError> {
        return Just(FindMovieEntity(search: [], totalResults: 1, response: true))
            .setFailureType(to: RequestError.self)
            .eraseToAnyPublisher()
    }

    func saveToLocal(movie: SearchEntity) -> AnyPublisher<Bool, Never> {
        return Just(true)
            .eraseToAnyPublisher()
    }

    func getMoviesFromLocal() -> AnyPublisher<[SearchEntity], Error> {
        return Just([SearchEntity()])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func isCoreDataEmpty() -> Bool {
        return true
    }
}
