//
//  FindMovieUseCaseTest.swift
//  FindMovieTests
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import XCTest
import Combine
@testable import FindMovie

internal final class FindMovieUseCaseTest: XCTestCase {
    private var useCase: FindMovieUseCaseProtocol?
    private var cancelBag = CancelBag()
    private var mockLocalStorage = MockLocalStorageStack.shared
    
    override func setUp() {
        super.setUp()
        mockLocalStorage.deleteAllData()
        useCase = FindMovieUseCase(networking: MockAlamofireHttpClient(),
                                   storageStack: mockLocalStorage)
    }
    
    override func tearDown() {
        useCase = nil
        super.tearDown()
    }
    
    func testFindMovie() {
        // Given
        let keyword = "I poli pote den koimatai"
        let page = 1
        let expectation = XCTestExpectation(description: "Find movie expectation")
        
        // When
        useCase?.findMovie(keyword: keyword, page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Failed to find movie with error: \(error)")
                }
                expectation.fulfill()
            } receiveValue: { findMovieEntity in
                // Then
                XCTAssertNotNil(findMovieEntity)
            }
            .store(in: cancelBag)
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testIsCoreDataEmpty() {
        // When
        let isEmpty = useCase?.isCoreDataEmpty() ?? false
        
        // Then
        XCTAssertTrue(isEmpty, "CoreData should be empty initially")
    }
    
    func testSaveToLocal() {
        // Given
        let movie = SearchEntity(title: "Robocar Poli",
                                 year: "2022",
                                 poster: "https://m.media-amazon.com/images/M/MV5BMmEzOTc2NWUtYjJiMy00Mzc5LTkxYTctMmZlMzg2Y2MxNDA4XkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg")
        let expectation = XCTestExpectation(description: "Save to local expectation")
        
        // When
        useCase?.saveToLocal(movie: movie)
            .sink { _ in
                // Then
                XCTAssert(true, "Successfully saved to local")
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetMoviesFromLocal() {
        // Given
        let expectation = XCTestExpectation(description: "Get movies from local expectation")
        mockLocalStorage.insertDefaultValues()
        
        // When
        useCase?.getMoviesFromLocal()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Failed to get movies from local with error: \(error)")
                }
                expectation.fulfill()
            } receiveValue: { searchEntities in
                // Then
                XCTAssertNotNil(searchEntities)
            }
            .store(in: cancelBag)
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
}
