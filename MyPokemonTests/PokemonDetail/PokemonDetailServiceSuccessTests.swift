//
//  PokemonDetailServiceSuccessTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

final class PokemonDetailServiceSuccessTests: XCTestCase {
  var networkingManagerMock: NetworkingManagerImpl!
  var detailService: PokemonDetailService!

  var result: PokemonDetailService.PokemonDetailResponse?
  var expectation: XCTestExpectation?

  override func setUp() {
    networkingManagerMock = NetworkmanagerPokemonDetailSuccessMock()
    detailService = PokemonDetailService(networkingManager: networkingManagerMock)
    detailService.delegate = self
  }
  
  override func tearDown() {
    result = nil
    detailService = nil
    networkingManagerMock = nil
  }
  
  func test_with_successful_response_and_update_result() {
    XCTAssertNil(result, "Initial result should be nil")

    expectation = expectation(description: "Result update!")
    detailService.load("https://pokeapi.co/api/v2/pokemon/1/")
    waitForExpectations(timeout: 2)
    
    let expectedResult = PokemonDetail(
      id: 1,
      name: "Bulbasaur",
      height: 7,
      weight: 69,
      imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
      types: ["grass", "poison"]
    )
    
    XCTAssertNotNil(result, "This is successful case and result should not be nil")
    XCTAssertEqual(result?.id, expectedResult.id,"The Pokemon id should be 1")
    XCTAssertEqual(result?.name.capitalized, expectedResult.name,"The Pokemon name should be Bulbasaur")
    XCTAssertEqual(result?.weight, expectedResult.weight,"The Pokemon weight should be 69")
    XCTAssertEqual(result?.height, expectedResult.height,"The Pokemon height should be 7")
    XCTAssertEqual(result?.types.count, expectedResult.types.count,"The Pokemon types count should be 2")
    XCTAssertEqual(result?.sprites.imageUrl, expectedResult.imageUrl, "The Pokemon imageUrl should be \(expectedResult.imageUrl)")
  }
}

extension PokemonDetailServiceSuccessTests: PokemonDetailViewModelInput {
  func onFetchCompletd(_ result: PokemonDetailService.PokemonDetailResponse) {
    self.result = result
    expectation?.fulfill()
    expectation = nil
  }
  
  func onFetchFailed(_ result: Error) {
    XCTFail("This test case should not be failed.")
  }
}
