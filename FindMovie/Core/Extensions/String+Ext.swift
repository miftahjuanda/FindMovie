//
//  String+Ext.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation

extension String {
    func isStringURL() -> Bool {
        if let url = URL(string: self) {
            return url.scheme != nil && url.host != nil
        }
        return false
    }
}
