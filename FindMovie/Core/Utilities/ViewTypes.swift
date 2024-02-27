//
//  ViewTypes.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

internal enum ViewTypes<T: Any>: Equatable {
    case loading
    case success(T)
    case noResults
    case failure(String)
}

extension ViewTypes {
    static func == (lhs: ViewTypes, rhs: ViewTypes) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.success(lhsValue), .success(rhsValue)):
            return lhsValue as AnyObject === rhsValue as AnyObject
        case (.noResults, .noResults):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}

