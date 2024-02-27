//
//  LocalStorageStack.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import CoreData

protocol LocalStorageStackProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
}

internal final class LocalStorageStack: LocalStorageStackProtocol {
    static let shared = LocalStorageStack()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalMovieData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
