//
//  PokemonListViewModelSuccessTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

class PokemonListViewModelSuccessTests: XCTestCase {
  var apiServiceMock: PokemonListServiceImpl!
  var persistenceServiceMock: PokemonPersistenceServiceImpl!
  
  var viewModel: PokemonListViewModel!

  var expectation: XCTestExpectation?

  override func setUp() {
    apiServiceMock = PokemonListServiceSuccessMock()
    persistenceServiceMock = PokemonPersistenceServiceSuccessMock()
    viewModel = PokemonListViewModel(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
    
    apiServiceMock.delegate = viewModel
    viewModel.delegate = self
  }
  
  override func tearDown() {
    viewModel = nil
    apiServiceMock = nil
    persistenceServiceMock = nil
  }
  
  func test_with_successful_response_and_update_results_result_should_be_20() {
    expectation = expectation(description: "Fetch list done")
    viewModel.fetchList()
    XCTAssertEqual(viewModel.fetchState, PokemonListFetchState.isFetching)
    waitForExpectations(timeout: 2)
    XCTAssertNil(viewModel.fetchState, "Fetching state should be nil")
    XCTAssertEqual(viewModel.sections.count, 20)
  }
  
  func test_with_successful_response_and_update_results_twice_result_should_be_40() {
    expectation = expectation(description: "Fetch list first time done")
    viewModel.fetchList()
    XCTAssertEqual(viewModel.fetchState, PokemonListFetchState.isFetching)
    waitForExpectations(timeout: 2)
    XCTAssertNil(viewModel.fetchState, "Fetching state should be nil")
    XCTAssertEqual(viewModel.sections.count, 20)
    
    expectation = expectation(description: "Fetch list second time done")
    viewModel.fetchList()
    XCTAssertEqual(viewModel.fetchState, PokemonListFetchState.isFetching)
    waitForExpectations(timeout: 2)
    XCTAssertNil(viewModel.fetchState, "Fetching state should be nil")
    XCTAssertEqual(viewModel.sections.count, 40)
  }
}

extension PokemonListViewModelSuccessTests: PokemonListViewModelDelegate {
  func refresh() {
    expectation?.fulfill()
    expectation = nil
  }
  func updateFetchState() {}
}
