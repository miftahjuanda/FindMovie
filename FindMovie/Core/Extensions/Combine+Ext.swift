//
//  Combine+Ext.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Combine

internal class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    public init() {}
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
