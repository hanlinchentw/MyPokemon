//
//  PokemonListServiceFailureTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

protocol PokemonListServiceFailureTestsSpec {
  func test_with_successful_response_and_update_results()
}

final class PokemonListServiceFailureTests: XCTestCase, PokemonListServiceFailureTestsSpec {
  var networkingManagerMock: NetworkingManagerImpl!
  var listService: PokemonListService!
  
  var results: Array<Pokemon>?
  var error: Error?
  var expectation: XCTestExpectation?
  
  override func setUp() {
    networkingManagerMock = NetworkingManagerPokemonResponseFailureMock()
    listService = PokemonListService(networkingManager: networkingManagerMock)
    listService.delegate = self
  }
  
  override func tearDown() {
    results = nil
    error = nil
    listService = nil
    networkingManagerMock = nil
  }
  
  func test_with_successful_response_and_update_results() {
    expectation = expectation(description: "Error Occured!")
    XCTAssertEqual(listService.offset, 0)
    XCTAssertNil(results, "Before loading any data, results should be nil.")
    XCTAssertNil(error, "Before loading any data, error should be nil.")

    listService.loadMore()
    waitForExpectations(timeout: 2)
    
    XCTAssertEqual(listService.offset, 0, "Offset should not be updated because of failure api request")
    XCTAssertNil(results, "After failed to load any data, results should be nil.")
    XCTAssertNotNil(error, "Before loading any data, error should not be nil.")
  }
}

extension PokemonListServiceFailureTests: PokemonListViewModelInput {
  func onFetchCompletd(_ results: Array<Pokemon>) {
    XCTFail("This is test case should be failed.")
  }
  
  func onFetchFailed(_ error: Error) {
    self.error = error
    self.expectation?.fulfill()
    self.expectation = nil
  }
}
