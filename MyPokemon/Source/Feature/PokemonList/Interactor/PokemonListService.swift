//
//  PokemonListService.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol PokemonListServiceImpl {
  func loadMore()
}

protocol PokemonListViewModelInput: AnyObject {
  func onFetchCompletd(_ result: Array<Pokemon>)
  func onFetchFailed(_ error: Error)
}

class PokemonListService: PokemonListServiceImpl, NetworkRequestNotify {
  typealias Response = PokemonResponse
  
  weak var delegate: (any PokemonListViewModelInput)?

  var offset = 0
  var limit = 20

  func loadMore() {
    let request = GetPokemonRequest()
    NetworkingManager.shared.request(type: Response.self, request) { [weak self] result in
      self?.onHandleFetchResult(result)
      self?.offset += 1
    }
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

extension PokemonListService {
  struct PokemonResponse: Codable {
    var results: Array<PokemonResult>
  }
  
  struct PokemonResult: Codable {
    var name: String
    var url: String
  }
}
