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
  
  private let networkingManager: NetworkingManagerImpl
  
  weak var delegate: (any PokemonListViewModelInput)?
  
  var offset = 0
  var limit = 20

  init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
    self.networkingManager = networkingManager
  }

  func loadMore() {
    let request = GetPokemonRequest(offset: offset)
    networkingManager.request(type: Response.self, session: URLSession.shared, request.url, request.method, useCache: true) { [weak self] result in
      self?.onHandleFetchResult(result)
    }
  }
  
  func onHandleFetchResult(_ result: Result<Response, Error>) {
    switch result {
    case .success(let success):
      let result = success.results.map { Pokemon(name: $0.name.capitalized, detailUrl: $0.url) }
      delegate?.onFetchCompletd(result)
      self.offset += 20
    case .failure(let failure):
      delegate?.onFetchFailed(failure)
    }
  }
}

extension PokemonListService {
  struct PokemonResponse: Codable, Equatable {
    var count: Int
    var next: String?
    var results: Array<PokemonResult>
  }
  
  struct PokemonResult: Codable, Equatable {
    var name: String
    var url: String
  }
}
