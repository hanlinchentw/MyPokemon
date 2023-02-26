//
//  PokemonListViewModelSuccessTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

protocol PokemonListViewModelSuccessTestsSpec {
  func test_with_successful_response_and_update_results_result_should_be_20()
  func test_with_successful_response_and_update_results_twice_result_should_be_40()
  func test_with_successful_response_and_capture_top_3()
  func test_with_successful_response_capture_and_release_one()
}

class PokemonListViewModelSuccessTests: XCTestCase, PokemonListViewModelSuccessTestsSpec {
  var apiServiceMock: PokemonListServiceSuccessMock!
  var persistenceServiceMock: PokemonPersistenceServiceSuccessMock!
  
  var viewModel: PokemonListViewModel!
  
  var expectation: XCTestExpectation?
  
  override func setUp() {
    apiServiceMock = PokemonListServiceSuccessMock()
    persistenceServiceMock = PokemonPersistenceServiceSuccessMock(manager: PersistenceManager(testSuite: self.name))
    viewModel = PokemonListViewModel(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
    
    apiServiceMock.delegate = viewModel
    persistenceServiceMock.delegate = viewModel
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
    XCTAssertEqual(viewModel.fetchingState, PokemonListFetchState.isFetching)
    waitForExpectations(timeout: 2)
    XCTAssertNil(viewModel.fetchingState, "Fetching state should be nil")
    XCTAssertEqual(viewModel.numberOfSection, 1)
    XCTAssertEqual(viewModel.numberOfRows(in: 0), 20)
  }
  
  func test_with_successful_response_and_update_results_twice_result_should_be_40() {
    expectation = expectation(description: "Fetch list first time done")
    viewModel.fetchList()
    XCTAssertEqual(viewModel.fetchingState, PokemonListFetchState.isFetching)
    waitForExpectations(timeout: 2)
    XCTAssertNil(viewModel.fetchingState, "Fetching state should be nil")
    XCTAssertEqual(viewModel.numberOfSection, 1)
    XCTAssertEqual(viewModel.numberOfRows(in: 0), 20)
    
    expectation = expectation(description: "Fetch list second time done")
    viewModel.fetchList()
    XCTAssertEqual(viewModel.fetchingState, PokemonListFetchState.isFetching)
    waitForExpectations(timeout: 2)
    XCTAssertNil(viewModel.fetchingState, "Fetching state should be nil")
    XCTAssertEqual(viewModel.numberOfSection, 1)
    XCTAssertEqual(viewModel.numberOfRows(in: 0), 40)
  }
  
  func test_with_successful_response_and_capture_top_3() {
    let top3: [IndexPath] = [0, 1, 2].map { IndexPath(row: $0, section: 0) }
    expectation = expectation(description: "Fetch list first")
    viewModel.fetchList()
    waitForExpectations(timeout: 2)
    
    for index in top3 {
      expectation = expectation(description: "Capture")
      let itemViewModel = viewModel.cellViewModel(for: index)
      viewModel.didTapBtn(itemViewModel.pokemon, itemViewModel.isCapture)
      waitForExpectations(timeout: 2)
      XCTAssert(viewModel.cellViewModel(for: index).isCapture, "\(itemViewModel.name) should be Captured")
    }
  }
  
  func test_with_successful_response_capture_and_release_one() {
    let indexPath = IndexPath(row: 0, section: 0)
    expectation = expectation(description: "Fetch list first")
    viewModel.fetchList()
    waitForExpectations(timeout: 2)
    
    expectation = expectation(description: "Capture")
    let itemViewModel = viewModel.cellViewModel(for: indexPath)
    viewModel.didTapBtn(itemViewModel.pokemon, itemViewModel.isCapture)
    waitForExpectations(timeout: 2)
    XCTAssert(viewModel.cellViewModel(for: indexPath).isCapture, "\(itemViewModel.name) should be Captured")
    
    expectation = expectation(description: "Release")
    viewModel.didTapBtn(itemViewModel.pokemon, itemViewModel.isCapture)
    waitForExpectations(timeout: 2)
    XCTAssertFalse(viewModel.cellViewModel(for: indexPath).isCapture, "\(itemViewModel.name) should be Released")
  }
}

extension PokemonListViewModelSuccessTests: PokemonListViewModelDelegate {
  func onPocketChange() {
    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
      self.expectation?.fulfill()
      self.expectation = nil
    })
  }
  
  func refresh() {
    // workround: write data need time, add 0.5s delay
    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
      self.expectation?.fulfill()
      self.expectation = nil
    })
  }
  func updateFetchState() {}
}
