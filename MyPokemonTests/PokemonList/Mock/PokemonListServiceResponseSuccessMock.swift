//
//  PokemonListServiceResponseSuccessMock.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import XCTest
@testable import MyPokemon

class PokemonListServiceResponseSuccessMock: PokemonListServiceImpl, NetworkRequestNotify {
  weak var delegate: (any PokemonListViewModelInput)?

  typealias Response = PokemonListService.PokemonResponse
  
  func loadMore() {
    guard let path = Bundle.main.path(forResource: "PokemonStaticData", ofType: "json"),
          let data = FileManager.default.contents(atPath: path) else {
      fatalError("PokemonStaticData doesn't exist")
    }
    let decoder = JSONDecoder()
    let res = try! decoder.decode(Response.self, from: data)
    
    onHandleFetchResult(.success(res))
  }
  
  func onHandleFetchResult(_ result: Result<Response, Error>) {
    switch result {
    case .success(let success):
      let result = success.results.map { Pokemon(name: $0.name.capitalized, detailUrl: $0.url) }
      delegate?.onFetchCompletd(result)
    case .failure(let failure):
      delegate?.onFetchFailed(failure)
    }
  }
}
