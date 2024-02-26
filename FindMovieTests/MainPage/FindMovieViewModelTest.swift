//
//  FindMovieViewModelTest.swift
//  FindMovieTests
//
//  Created by Miftah Juanda Batubara on 26/02/24.
//

import XCTest
import Combine
@testable import FindMovie

internal final class FindMovieViewModelTest: XCTestCase {
    var viewModel: FindMovieViewModel!
    var mockUseCase: MockFindMovieUseCase!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockUseCase = MockFindMovieUseCase()
        viewModel = FindMovieViewModel(useCase: mockUseCase)
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
    }
    
    func testFindMovieSuccess() throws {
        let expectation = XCTestExpectation(description: "Find Movie Success")
        
        viewModel.findMovie(keyword: "I poli pote den koimatai")
        
        viewModel.viewType.sink { viewTypes in
            switch viewTypes {
            case .success(let searchEntities):
                XCTAssertEqual(searchEntities.count, 1)
                XCTAssertEqual(searchEntities.first?.title, "I poli pote den koimatai")
                expectation.fulfill()
            default:
                break
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFindMovieFailure() throws {
        let expectation = XCTestExpectation(description: "Find Movie Failure")
        
        mockUseCase.shouldFail = true
        viewModel.findMovie(keyword: "test")
        
        viewModel.viewType.sink { viewTypes in
            switch viewTypes {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            default:
                break
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPagination() throws {
        let expectation = XCTestExpectation(description: "Pagination Success")
        
        viewModel.viewType.sink { viewTypes in
            switch viewTypes {
            case .success(let searchEntities):
                XCTAssertNotNil(searchEntities)
                XCTAssertEqual(searchEntities.count, 1)
                expectation.fulfill()
            default:
                break
            }
        }.store(in: &cancellables)
        
        viewModel.findMovie(keyword: "poli")
        
        let paginationExpectation = XCTestExpectation(description: "Pagination Success")
        
        viewModel.viewType.sink { viewTypes in
            switch viewTypes {
            case .success(let searchEntities):
                XCTAssertEqual(searchEntities.count, 1)
                paginationExpectation.fulfill()
            default:
                break
            }
        }.store(in: &cancellables)
        
        viewModel.pagination()
        
        wait(for: [expectation, paginationExpectation], timeout: 2.0)
    }
}
