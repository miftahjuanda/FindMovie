//
//  FindMovieUseCase.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import CoreData
import Combine

protocol FindMovieUseCaseProtocol {
    func findMovie(keyword: String, page: Int) -> AnyPublisher<FindMovieEntity, RequestError>
    func saveToLocal(movie: SearchEntity) -> AnyPublisher<Bool, Never>
    func getMoviesFromLocal() -> AnyPublisher<[SearchEntity], Error>
    func isCoreDataEmpty() -> Bool
}

internal final class FindMovieUseCase: FindMovieUseCaseProtocol {
    private let networking: HTTPClient
    private let storageStack: LocalStorageStackProtocol
    
    init(networking: HTTPClient = AlamofireHttpClient(), storageStack: LocalStorageStackProtocol = LocalStorageStack.shared)  {
        self.networking = networking
        self.storageStack = storageStack
    }
    
    func findMovie(keyword: String, page: Int) -> AnyPublisher<FindMovieEntity, RequestError> {
        let request = networking.request(url: FindMovieRequest(keyword: keyword, page: page))
        return request
    }
    
    func saveToLocal(movie: SearchEntity) -> AnyPublisher<Bool, Never> {
        let context = storageStack.viewContext
        let item = LocalMovieData(context: context)
        item.imageUrl = movie.poster
        item.title = movie.title
        item.year = movie.year
        
        return Future { promise in
            do {
                try context.save()
                promise(.success(true))
            } catch {
                promise(.success(false))
            }
        }.eraseToAnyPublisher()
    }
    
    func getMoviesFromLocal() -> AnyPublisher<[SearchEntity], Error> {
        let fetchRequest: NSFetchRequest<LocalMovieData> = LocalMovieData.fetchRequest()
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            do {
                let items = try self.storageStack.viewContext.fetch(fetchRequest)
                let mapDataItems = FindMovieProcessor().mapLocalDataToEntity(items)
                
                promise(.success(mapDataItems))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func isCoreDataEmpty() -> Bool {
        let context = storageStack.viewContext
        let fetchRequest: NSFetchRequest<LocalMovieData> = LocalMovieData.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            return false
        }
    }
}
