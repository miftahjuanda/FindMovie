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
    var isFetchPagination: Bool { get }
    
    func findMovie(keyword: String)
    func pagination()
}

internal class FindMovieViewModel: FindMovieViewModelProtocol {
    private let useCase: FindMovieUseCaseProtocol
    private let cancelBag = CancelBag()
    
    private var currentPage: Int = 1
    private var totalResults: Int = 0
    private var keywordValue: String = ""
    private var disableFetch: Bool = false
    private var findMovie = FindMovieEntity(search: [], totalResults: 0)
    var viewType: CurrentValueSubject<ViewTypes<[SearchEntity]>, Never> = .init(.loading)
    var isFetchPagination: Bool = false
    
    init(useCase: FindMovieUseCaseProtocol = FindMovieUseCase() ) {
        self.useCase = useCase
    }
    
    func findMovie(keyword: String) {
        resetData(keyword: keyword)
        
        if !isFetchPagination {
            isFetchPagination = true
            viewType.send(.loading)
        }
        
        useCase.findMovie(keyword: keywordValue, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] finished in
                guard let self = self else { return }
                
                if case .failure(let error) = finished {
                    self.disableFetch = true
                    
                    switch error {
                    case .anyError(let anyError):
                        self.viewType.send(.failure(anyError))
                    case .sessionError(let sessionError):
                        self.viewType.send(.failure(sessionError.localizedDescription))
                    }
                }
                self.isFetchPagination = false
                
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                if !value.search.isEmpty {
                    if findMovie.totalResults != value.totalResults {
                        self.findMovie = value
                        self.currentPage += 1
                    } else {
                        self.totalResults = self.findMovie.search.count
                        self.findMovie.search.append(contentsOf: value.search)
                        self.currentPage += 1
                    }
                    self.isFetchPagination = false
                    self.viewType.send(.success(self.findMovie.search))
                } else {
                    disableFetch = true
                    self.viewType.send(.noResults)
                }
                
            }).store(in: cancelBag)
    }
    
    func pagination() {
        isFetchPagination = true
        
        if !disableFetch && !findMovie.search.isEmpty && totalResults <= findMovie.totalResults {
            findMovie(keyword: keywordValue)
        }
    }
    
    private func resetData(keyword: String) {
        if keywordValue != keyword {
            isFetchPagination = false
            disableFetch = false
            currentPage = 1
            totalResults = 0
            keywordValue = keyword
            findMovie = FindMovieEntity(search: [], totalResults: 0)
        }
    }
}
