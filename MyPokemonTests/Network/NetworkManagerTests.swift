//
//  NetworkManagerTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

protocol NetworkingManagerTestSpec {
  func test_with_success_response_is_valid()
  func test_with_failed_response_status_code_is_invalid()
  func test_with_successful_response_with_wrong_decodable_type_is_invalid()
}

class NetworkingManagerTests: XCTestCase, NetworkingManagerTestSpec {
  private var session: URLSession!
  
  override func setUp() {
    let configuration = URLSessionConfiguration.ephemeral // no cache
    configuration.protocolClasses = [MockURLSessionProtocol.self]
    session = URLSession(configuration: configuration)
  }
  
  override func tearDown() {
    session = nil
  }
  
  func test_with_success_response_is_valid() {
    let MOCK_DATA_NAME = "PokemonStaticData"
    let STATUS_CODE = 200
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    guard let path = Bundle.main.path(forResource: MOCK_DATA_NAME, ofType: "json"),
          let data = FileManager.default.contents(atPath: path) else {
      XCTFail("\(MOCK_DATA_NAME) doesn't exist.")
      return
    }
    
    MockURLSessionProtocol.mockResponseHandler = {
      let response = HTTPURLResponse(url: url,
                                     statusCode: STATUS_CODE,
                                     httpVersion: nil,
                                     headerFields: nil)
      return (response!, data)
    }
    
    NetworkingManager.shared.request(type: PokemonListService.PokemonResponse.self, session: session, url, .GET, useCache: false) { result in
      switch result {
      case .success(let success):
        let decoder = JSONDecoder()
        let res = try? decoder.decode(PokemonListService.PokemonResponse.self, from: data)
        XCTAssertNotNil(res, "The response should be decoded properly")
        XCTAssertEqual(res, success, "The response should be the same as mock data")
      case .failure(_):
        XCTFail("This test should not be failed.")
      }
    }
  }
  
  func test_with_failed_response_status_code_is_invalid() {
    let STATUS_CODE = 400
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    MockURLSessionProtocol.mockResponseHandler = {
      let response = HTTPURLResponse(url: url,
                                     statusCode: STATUS_CODE,
                                     httpVersion: nil,
                                     headerFields: nil)
      return (response!, nil)
    }
    
    NetworkingManager.shared.request(type: PokemonListService.PokemonResponse.self, session: session, url, .GET, useCache: false) { result in
      switch result {
      case .success(_):
        XCTFail("This test should be failed.")
      case .failure(let failure):
        guard let networkingError = failure as? NetworkingManager.NetworkingError else {
          XCTFail("Wrong type of error=\(failure), expecting NetworkingManager.NetworkingError")
          return
        }
        XCTAssertEqual(networkingError,
                       NetworkingManager.NetworkingError.invalidStatusCode(statusCode: STATUS_CODE),
                       "Error should be NetworkingError.invalidStatusCode(statusCode: 400)")
        
      }
    }
  }
  
  func test_with_successful_response_with_wrong_decodable_type_is_invalid() {
    let STATUS_CODE = 200
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    MockURLSessionProtocol.mockResponseHandler = {
      let response = HTTPURLResponse(url: url,
                                     statusCode: STATUS_CODE,
                                     httpVersion: nil,
                                     headerFields: nil)
      return (response!, nil)
    }
    
    NetworkingManager.shared.request(type: PokemonListService.PokemonResult.self, session: session, url, .GET, useCache: false) { result in
      switch result {
      case .success(_):
        XCTFail("This test should be failed.")
      case .failure(let failure):
        guard let networkingError = failure as? NetworkingManager.NetworkingError else {
          XCTFail("Wrong type of error=\(failure), expecting NetworkingManager.NetworkingError")
          return
        }
        XCTAssertEqual(networkingError, NetworkingManager.NetworkingError.failedToDecode, "Error should be NetworkingError.failedToDecode")
      }
    }
  }
}
