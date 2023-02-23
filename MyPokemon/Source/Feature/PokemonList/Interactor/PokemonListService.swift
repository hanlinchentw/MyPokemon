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
  func onFetchFailed(_ result: Error)
}

class PokemonListService: PokemonListServiceImpl, NetworkRequestNotify {
  typealias Response = PokemonResponse
  
  weak var delegate: (any PokemonListViewModelInput)?
  
  var nextUrlString: String?
  
  func loadMore() {
    if let nextUrlString = nextUrlString {
      let nextUrl = URL(string: nextUrlString)
      NetworkingManager.shared.request(type: Response.self, nextUrl, .GET) { [weak self] result in
        self?.onHandleFetchResult(result)
      }
    } else {
      let request = GetPokemonRequest()
      NetworkingManager.shared.request(type: Response.self, request) { [weak self] result in
        self?.onHandleFetchResult(result)
      }
    }
  }
  
  func onHandleFetchResult(_ result: Result<Response, Error>) {
    switch result {
    case .success(let success):
      self.nextUrlString = success.next
      let pokemonLists = success.results
      delegate?.onFetchCompletd(pokemonLists)
    case .failure(let failure):
      delegate?.onFetchFailed(failure)
    }
  }
}

extension PokemonListService {
  struct PokemonResponse: Codable {
    var next: String
    var results: Array<Pokemon>
  }
}
