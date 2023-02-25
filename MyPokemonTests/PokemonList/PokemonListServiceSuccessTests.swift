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
  func test_with_successful_response_and_update_result_mulptiple_time()
}

final class PokemonListServiceSuccessTests: XCTestCase, PokemonListServiceSuccessTestsSpec {
  var networkingManagerMock: NetworkingManagerImpl!
  var listService: PokemonListService!

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
    XCTAssertEqual(listService.offset, 0)
    
    listService.loadMore()
    waitForExpectations(timeout: 2)
    
    XCTAssertEqual(listService.offset, 20)
    XCTAssertEqual(results.count, 20, "Total count of results should be 20")
  }
  
  func test_with_successful_response_and_update_result_mulptiple_time() {
    expectation = expectation(description: "Results update first time!")
    XCTAssertEqual(listService.offset, 0)
    
    listService.loadMore()
    waitForExpectations(timeout: 2)
    
    XCTAssertEqual(listService.offset, 20)
    XCTAssertEqual(results.count, 20, "Total count of results should be 20")
    
    
    expectation = expectation(description: "Results update second time!")
    listService.loadMore()
    waitForExpectations(timeout: 2)
    
    XCTAssertEqual(listService.offset, 40)
    XCTAssertEqual(results.count, 40, "Total count of results should be 40")
    
    expectation = expectation(description: "Results update third time!")
    listService.loadMore()
    waitForExpectations(timeout: 2)
    
    XCTAssertEqual(listService.offset, 60)
    XCTAssertEqual(results.count, 60, "Total count of results should be 60")
  }
}

extension PokemonListServiceSuccessTests: PokemonListViewModelInput {
  func onFetchCompletd(_ results: Array<Pokemon>) {
    self.results += results
    self.expectation?.fulfill()
    self.expectation = nil
  }
  
  func onFetchFailed(_ error: Error) {
    XCTFail("This is test case should not be failed.")
  }
}
