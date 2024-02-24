//
//  AlamofireHttpClient.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Alamofire
import Combine

internal protocol HTTPClient {
    func request<T: RestApi>(url: T) -> AnyPublisher<T.Response, RequestError>
}

internal final class AlamofireHttpClient: NSObject, HTTPClient {
    public override init() {}
    
    func request<T: RestApi>(url: T) -> AnyPublisher<T.Response, RequestError> {
        return Future { promise in
            AF.request(url.toUrlRequest()).responseData { response in
                if let error = response.error?.errorDescription {
                    promise(.failure(.anyError(error)))
                } else if let data = response.data {
                    if let mapData = try? url.map(data) {
                        promise(.success(mapData))
                    } else {
                        promise(.failure(.anyError("Error mapping data.")))
                    }
                } else {
                    if let error = response.error {
                        promise(.failure(.sessionError(error: error)))
                    } else {
                        promise(.failure(.anyError("Error undifine.")))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

internal enum RequestError: Error {
    case sessionError(error: Error)
    case anyError(String)
}
