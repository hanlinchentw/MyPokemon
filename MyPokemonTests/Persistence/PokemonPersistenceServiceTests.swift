//
//  PokemonPersistenceServiceTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
import RealmSwift
@testable import MyPokemon

protocol PokemonPersistenceServiceTestsSpec {
  func test_with_three_capture_count_be_3()
  func test_with_two_capture_one_release_count_be_2()
  func test_with_release_not_exist_pokemon_throw_error()
}

class PokemonPersistenceServiceTests: XCTestCase, PokemonPersistenceServiceTestsSpec {
  private var service: PokemonPersistenceService!
  
  var expectation: XCTestExpectation?

  var store: [RLM_Pokemon] = []
  
  override func setUp() {
    let manager = PersistenceManager(testSuite: self.name)
    service = PokemonPersistenceService(manager: manager)

    service.delegate = self
  }
  
  override func tearDown() {
    service = nil
    store = []
  }
  
  func test_with_three_capture_count_be_3() {
    // Capture one pokemon!
    expectation = expectation(description: "Capture one pokemon!")
    let pokemon1 = Pokemon(name: "Han Lin", detailUrl: "https://google.com")
    service.capture(pokemon1)
    waitForExpectations(timeout: 2)
    XCTAssertEqual(store.count, 1)
    
    // Capture two pokemon!
    expectation = expectation(description: "Capture second pokemon!")
    let pokemon2 = Pokemon(name: "Casey", detailUrl: "https://google.com")
    service.capture(pokemon2)
    waitForExpectations(timeout: 2)
    XCTAssertEqual(store.count, 2)
    
    // Capture three pokemon!
    expectation = expectation(description: "Capture third pokemon!")
    let pokemon3 = Pokemon(name: "Paul", detailUrl: "https://google.com")
    service.capture(pokemon3)
    waitForExpectations(timeout: 2)
    XCTAssertEqual(store.count, 3)
  }
  
  func test_with_two_capture_one_release_count_be_2() {
    // Capture one pokemon!
    expectation = expectation(description: "Capture one pokemon!")
    let pokemon1 = Pokemon(name: "Han Lin", detailUrl: "https://google.com")
    service.capture(pokemon1)
    waitForExpectations(timeout: 2)
    XCTAssertEqual(store.count, 1)
    
    // Capture two pokemon!
    expectation = expectation(description: "Capture second pokemon!")
    let pokemon2 = Pokemon(name: "Casey", detailUrl: "https://google.com")
    service.capture(pokemon2)
    waitForExpectations(timeout: 2)
    XCTAssertEqual(store.count, 2)
    
    // Release one pokemon!
    expectation = expectation(description: "Release one pokemon!")
    try! service.release("Casey")
    waitForExpectations(timeout: 2)
    XCTAssertEqual(store.count, 1)
  }
  
  func test_with_release_not_exist_pokemon_throw_error() {
    do {
      try service.release("Casey")
    } catch {
      guard let persistenceError = error as? PokemonPersistenceService.PokemonPersistenceError else {
        XCTFail("Wrong type of error, expecting PokemonPersistenceError")
        return
      }
      XCTAssertEqual(persistenceError,
                     PokemonPersistenceService.PokemonPersistenceError.pokemonNotExist,
                     "Error should be PokemonPersistenceError.pokemonNotExist")
    }
  }
}

extension PokemonPersistenceServiceTests: PokemonPersistenceServiceDelegate {
  func onDataInit(_ initial: Array<RLM_Pokemon>) {
    self.store = initial
  }

  func onDataChanged(_ change: Array<RLM_Pokemon>) {
    self.store = change
    expectation?.fulfill()
    expectation = nil
  }
}
