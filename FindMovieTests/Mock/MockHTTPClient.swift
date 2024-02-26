//
//  MockHTTPClient.swift
//  FindMovieTests
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import Combine
import Alamofire
@testable import FindMovie

// MARK: - MockAlamofireHttpClient
internal final class MockAlamofireHttpClient: HTTPClient {
    lazy var result: Result<Data, AFError> = .success(self.stringToData())
    
    func request<T: RestApi>(url: T) -> AnyPublisher<T.Response, RequestError> {
        return Future { promise in
            switch self.result {
            case let .success(data):
                do {
                    let mappedData = try url.map(data)
                    promise(.success(mappedData))
                } catch {
                    promise(.failure(.anyError("Error mapping data.")))
                }
            case let .failure(error):
                promise(.failure(.sessionError(error: error)))
            }
        }.eraseToAnyPublisher()
    }
    
    private func stringToData() -> Data {
        let jsonString = """
        {
            "Search": [
                {
                    "Title": "I poli pote den koimatai",
                    "Year": "1984",
                    "imdbID": "tt0288743",
                    "Type": "movie",
                    "Poster": "https://m.media-amazon.com/images/M/MV5BMzY2NTE1NTYtZGQ5ZS00YTgwLTgyYTMtYmJhZDdmYjY0NWVmXkEyXkFqcGdeQXVyNDE5MTU2MDE@._V1_SX300.jpg"
                }
            ],
            "totalResults": "1",
            "Response": "True"
        }
        """
        
        if let jsonData = jsonString.data(using: .utf8) {
            return jsonData
        } else {
            return Data()
        }
    }
}
