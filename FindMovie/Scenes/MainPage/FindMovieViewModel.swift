//
//  FindMovieViewModel.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import Foundation
import Combine

protocol FindMovieViewModelProtocol {
    var viewType: CurrentValueSubject<ViewTypes<[SearchEntity]>, Never> { get }
    var isFetchingData: Bool { get }
    
    func findMovie(keyword: String)
    func pagination()
}

internal class FindMovieViewModel: FindMovieViewModelProtocol {
    private let useCase: FindMovieUseCaseProtocol
    private let cancelBag = CancelBag()
    
    private var currentPage: Int = 1
    private var keywordValue: String = ""
    private var movies: [SearchEntity] = []
    private var findMovie = FindMovieEntity(search: [], totalResults: 0) {
        didSet {
            movies.append(contentsOf: findMovie.search)
        }
    }
    
    var viewType: CurrentValueSubject<ViewTypes<[SearchEntity]>, Never> = .init(.loading)
    var isFetchingData: Bool = false
    
    init(useCase: FindMovieUseCaseProtocol = FindMovieUseCase() ) {
        self.useCase = useCase
    }
    
    func findMovie(keyword: String) {
        keywordValue = keyword
        viewType.send(.loading)
        isFetchingData = true
        
        useCase.findMovie(keyword: keywordValue, page: currentPage)
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
                self.isFetchingData = false
                
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if !value.search.isEmpty {
                    self.findMovie = value
                    self.viewType.send(.success(movies))
                } else {
                    self.viewType.send(.noResults)
                }
                self.isFetchingData = false
                
            }).store(in: cancelBag)
    }
    
    func pagination() {
        self.isFetchingData = true
        
        if !movies.isEmpty && movies.count != findMovie.totalResults {
            currentPage += 1
            findMovie(keyword: keywordValue)
        }
    }
    
}
