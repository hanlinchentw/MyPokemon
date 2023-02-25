//
//  PokemonDetailServiceFailureTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

final class PokemonDetailServiceFailureTests: XCTestCase {
  var networkingManagerMock: NetworkingManagerImpl!
  var detailService: PokemonDetailService!

  var result: PokemonDetailService.PokemonDetailResponse?
  var error: Error?
  var expectation: XCTestExpectation?

  override func setUp() {
    networkingManagerMock = NetworkmanagerPokemonDetailFailureMock()
    detailService = PokemonDetailService(networkingManager: networkingManagerMock)
    detailService.delegate = self
  }
  
  override func tearDown() {
    result = nil
    error = nil
    detailService = nil
    networkingManagerMock = nil
  }
  
  func test_with_successful_response_and_update_result() {
    XCTAssertNil(error, "This is failure case and error should not be nil")
    XCTAssertNil(result, "This is failure case and result should be nil")
    
    expectation = expectation(description: "Result update!")
    detailService.load("https://pokeapi.co/api/v2/pokemon/1/")
    waitForExpectations(timeout: 2)
    
    XCTAssertNotNil(error, "This is failure case and error should not be nil")
    XCTAssertNil(result, "This is failure case and result should be nil")
  }
}

extension PokemonDetailServiceFailureTests: PokemonDetailViewModelInput {
  func onFetchCompletd(_ result: PokemonDetailService.PokemonDetailResponse) {
    XCTFail("This test case should be failed.")
  }
  
  func onFetchFailed(_ result: Error) {
    self.error = result
    expectation?.fulfill()
    expectation = nil
  }
}
