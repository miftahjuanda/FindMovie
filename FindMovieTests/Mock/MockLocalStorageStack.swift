//
//  MockLocalStorageStack.swift
//  FindMovieTests
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import CoreData
@testable import FindMovie

internal final class MockLocalStorageStack: LocalStorageStackProtocol {
    static let shared = MockLocalStorageStack()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalMovieData")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
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
    
    // Method to insert default values for unit testing
    func insertDefaultValues() {
        let entity = NSEntityDescription.entity(forEntityName: "LocalMovieData", in: viewContext)
        
        // Example: Inserting a default movie entity
        let defaultMovie = NSManagedObject(entity: entity!, insertInto: viewContext)
        defaultMovie.setValue("I poli pote", forKey: "title")
        defaultMovie.setValue("2022", forKey: "year")
        defaultMovie.setValue("https://m.media-amazon.com/images/M/MV5BMzY2NTE1NTYtZGQ5ZS00YTgwLTgyYTMtYmJhZDdmYjY0NWVmXkEyXkFqcGdeQXVyNDE5MTU2MDE@._V1_SX300.jpg", forKey: "imageUrl")
        
        // Save changes to the context
        do {
            try viewContext.save()
        } catch {
            fatalError("Failed to save default values: \(error)")
        }
    }

    // Method to delete all data from the Core Data entity
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LocalMovieData")
        
        do {
            let objects = try persistentContainer.viewContext.fetch(fetchRequest)
            
            for case let object as NSManagedObject in objects {
                persistentContainer.viewContext.delete(object)
            }
            
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Failed to delete data: \(error)")
        }
    }
}
