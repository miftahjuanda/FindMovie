//
//  MockFindMovieUseCase.swift
//  FindMovieTests
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import Combine
@testable import FindMovie

internal final class MockFindMovieUseCase: FindMovieUseCaseProtocol {
    var shouldFail: Bool = false
    var isCoreData: Bool = false
    var moviesFromLocal: [SearchEntity] = []
    
    func findMovie(keyword: String, page: Int) -> AnyPublisher<FindMovieEntity, RequestError> {
        if shouldFail {
            return Result.Publisher(.failure(.sessionError(error: RequestError.anyError("failed"))))
                .eraseToAnyPublisher()
        } else {
            let searchEntity = SearchEntity(title: "I poli pote den koimatai", year: "1984", poster: "https://m.media-amazon.com/images/M/MV5BMzY2NTE1NTYtZGQ5ZS00YTgwLTgyYTMtYmJhZDdmYjY0NWVmXkEyXkFqcGdeQXVyNDE5MTU2MDE@._V1_SX300.jpg")
            let findMovieEntity = FindMovieEntity(search: [searchEntity], totalResults: 1, response: true)
            return Result.Publisher(.success(findMovieEntity))
                .eraseToAnyPublisher()
        }
    }
    
    func isCoreDataEmpty() -> Bool {
        return isCoreData
    }
    
    func getMoviesFromLocal() -> AnyPublisher<[SearchEntity], Error> {
        if isCoreData {
            return Result.Publisher(.success(moviesFromLocal))
                .eraseToAnyPublisher()
        } else {
            return Result.Publisher(.failure(RequestError.anyError("Failed")))
                .eraseToAnyPublisher()
        }
    }
    
    func saveToLocal(movie: SearchEntity) -> AnyPublisher<Bool, Never> {
        return Result.Publisher(.success(isCoreData))
            .eraseToAnyPublisher()
    }
}
