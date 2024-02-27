//
//  RestApi.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

internal protocol RestApi {
    /// Response model
    associatedtype Response: Decodable
    /// The target's base `URL`.
    var baseURL: String { get }
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    /// The params to be used in the request.
    var params: [String: Any] { get }
    /// The query items to be used in the request.
    var queryItems: [URLQueryItem]? { get }
    /// The minimum time required to handle a timeout request.
    var timeout: TimeInterval { get }
    
    // Data resulting from the request.
    func map(_ data: Data) throws -> Response
}

extension RestApi {
    internal var timeout: TimeInterval { 60 }
    internal var method: HTTPMethod { .get }
    internal var params: [String: Any] { [:] }
    internal var queryItems: [URLQueryItem]? { nil }
    
    /// Convert current object to URLRequest
    internal func toUrlRequest() -> URLRequest {
        guard let url = URL(string: baseURL)?.appendingPathComponent(path),
              var urlComp = URLComponents(
                url: url,
                resolvingAgainstBaseURL: true)
        else { return URLRequest(url: URL(string: "")!) }
        
        if let queryItems = queryItems {
            urlComp.queryItems = queryItems.compactMap({
                URLQueryItem(name: $0.name, value: String($0.value ?? ""))
            })
        }
        
        let headers = self.headers ?? [:]
        var urlReq = URLRequest(url: urlComp.url!)
        
        for (k, v) in headers {
            urlReq.addValue(v, forHTTPHeaderField: k)
        }
        
        if !params.isEmpty {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            urlReq.httpBody = jsonData
        }
        
        urlReq.httpMethod = method.rawValue
        return urlReq
    }
}

extension RestApi where Response: Decodable {
    internal func map(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

/// Represent HTTP method
public enum HTTPMethod: String {
    case get = "GET"
}
