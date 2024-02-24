//
//  ApiConfigManager.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

internal class ApiConfigManager {
    static let shared = ApiConfigManager()
    
    private init() {}
    
    private let apiKey = "491ca1b6"
    private let baseUrl = "https://www.omdbapi.com"
    
    func getApiKey() -> String {
        return apiKey
    }
    
    func getBaseUrl() -> String {
        return baseUrl
    }
}
