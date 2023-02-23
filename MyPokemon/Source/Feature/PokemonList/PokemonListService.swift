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

class PokemonListService: PokemonListServiceImpl {
  var nextUrlString: String?
  func loadMore() {
    if let nextUrlString = nextUrlString {
      let nextUrl = URL(string: nextUrlString)
      NetworkingManager.shared.request(type: PokemonResponse.self, nextUrl, .GET) { result in
        print("result \(result)")
      }
    } else {
      let request = GetPokemonRequest()
      NetworkingManager.shared.request(type: PokemonResponse.self, request) { result in
        print("result \(result)")
      }
    }
  }
}

private extension PokemonListService {
  struct PokemonResponse: Codable {
    var next: String
    var results: Array<Pokemon>
  }
}
