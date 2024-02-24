//
//  FindMovieViewModel.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation
import Combine

protocol FindMovieViewModelProtocol {
    var movies: [SearchEntity] { get }
    var viewType: CurrentValueSubject<ViewTypes<[SearchEntity]>, Never> { get }
    
    func findMovie(keyword: String)
}

internal class FindMovieViewModel: FindMovieViewModelProtocol {
    private let useCase: FindMovieUseCaseProtocol
    private let cancelBag = CancelBag()
    
    var viewType: CurrentValueSubject<ViewTypes<[SearchEntity]>, Never> = .init(.loading)
    var movies: [SearchEntity] = []
    private var findMovie = FindMovieEntity(search: [], totalResults: "") {
        didSet {
            movies.append(contentsOf: findMovie.search)
        }
    }
    
    init(useCase: FindMovieUseCaseProtocol = FindMovieUseCase() ) {
        self.useCase = useCase
    }
    
    func findMovie(keyword: String) {
        viewType.send(.loading)
        
        useCase.findMovie(keyword: keyword, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] finished in
                guard let self = self else { return }
                
                if case .failure(let error) = finished {
                    print("error: ", error)
                    switch error {
                    case .anyError(let anyError):
                        self.viewType.send(.failure(anyError))
                    case .sessionError(let sessionError):
                        self.viewType.send(.failure(sessionError.localizedDescription))
                    }
                }
                
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if !value.search.isEmpty {
                    self.findMovie = value
                    self.viewType.send(.success(movies))
                } else {
                    self.viewType.send(.noResults)
                }
                
            }).store(in: cancelBag)
    }
    
}
