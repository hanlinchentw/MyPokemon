//
//  PokemonListServiceTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

protocol PokemonListServiceSuccessTestsSpec {
  func test_with_successful_response_and_update_results()
}

final class PokemonListServiceSuccessTests: XCTestCase, PokemonListServiceSuccessTestsSpec {
  var networkingManagerMock: NetworkingManagerImpl!
  var listService: PokemonListService!

  var hasReachEnd = false
  var results: Array<Pokemon> = []
  var expectation: XCTestExpectation?

  override func setUp() {
    networkingManagerMock = NetworkingManagerPokemonResponseSuccessMock()
    listService = PokemonListService(networkingManager: networkingManagerMock)
    listService.delegate = self
  }
  
  override func tearDown() {
    results = []
    listService = nil
    networkingManagerMock = nil
  }
  
  func test_with_successful_response_and_update_results() {
    expectation = expectation(description: "Results update!")
    XCTAssertNil(listService.nextUrl, "Before loading any data, nextUrl should be nil")
    
    listService.loadMore()
    waitForExpectations(timeout: 2)

    XCTAssertEqual(listService.nextUrl, "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20", "After loading data, nextUrl should not be nil.")
    XCTAssertEqual(results.count, 20, "Total count of results should be 20")
  }
}

extension PokemonListServiceSuccessTests: PokemonListViewModelInput {
  func onFetchCompletd(_ results: Array<Pokemon>, hasReachEnd: Bool) {
    self.results += results
    self.hasReachEnd = hasReachEnd
    self.expectation?.fulfill()
    self.expectation = nil
  }
  
  func onFetchFailed(_ error: Error) {
    XCTFail("This is test case should not be failed.")
  }
}
