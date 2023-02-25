//
//  NetworkEndpointTests.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

protocol NetworkEndpointTestsSpec {
  func test_with_pokemon_endpoint_request_is_valid()
  func test_with_pokemon_endpoint_with20offset_request_is_valid()
}

class NetworkEndpointTests: XCTestCase, NetworkEndpointTestsSpec {

  func test_with_pokemon_endpoint_request_is_valid() {
    let pokemonEndpoint = GetPokemonRequest()
    
    var expectedURLComponents = URLComponents()
    expectedURLComponents.scheme = "https"
    expectedURLComponents.host = "pokeapi.co"
    expectedURLComponents.path = "/api/v2/pokemon"
    
    var requestQueryItems = [URLQueryItem]()
    ["offset":"0", "limit":"20"].forEach { item in
      requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
    }
    expectedURLComponents.queryItems = requestQueryItems
    
    XCTAssertEqual(pokemonEndpoint.host, expectedURLComponents.host, "The host should be pokeapi.co")
    XCTAssertEqual(pokemonEndpoint.path, expectedURLComponents.path, "The path should be /api/v2/pokemon")
    XCTAssertEqual(pokemonEndpoint.method, .GET, "The http method should be GET")
    XCTAssertEqual(pokemonEndpoint.queryItems, ["offset":"0", "limit":"20"], "The offset and limit should be 0 and 20 respectively")
    XCTAssertEqual(pokemonEndpoint.urlComponents, expectedURLComponents, "The generated doesn't match our endpoint")
  }
  
  func test_with_pokemon_endpoint_with20offset_request_is_valid() {
    let offset = 20
    
    let pokemonEndpoint = GetPokemonRequest(offset: 20)
    
    var expectedURLComponents = URLComponents()
    expectedURLComponents.scheme = "https"
    expectedURLComponents.host = "pokeapi.co"
    expectedURLComponents.path = "/api/v2/pokemon"
    
    var requestQueryItems = [URLQueryItem]()
    ["offset":"\(20)", "limit":"20"].forEach { item in
      requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
    }
    expectedURLComponents.queryItems = requestQueryItems
    
    XCTAssertEqual(pokemonEndpoint.host, expectedURLComponents.host, "The host should be pokeapi.co")
    XCTAssertEqual(pokemonEndpoint.path, expectedURLComponents.path, "The path should be /api/v2/pokemon")
    XCTAssertEqual(pokemonEndpoint.method, .GET, "The http method should be GET")
    XCTAssertEqual(pokemonEndpoint.queryItems, ["offset":"\(offset)", "limit":"20"], "The offset and limit should be 0 and 20 respectively")
    XCTAssertEqual(pokemonEndpoint.urlComponents, expectedURLComponents, "The generated doesn't match our endpoint")
  }
}

