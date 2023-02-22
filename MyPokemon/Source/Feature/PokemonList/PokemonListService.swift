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
  var nextUrl: String?
  func loadMore() {
    let url = nextUrl ?? PokemonEndpoint.url
    NetworkingManager.shared.request(type: PokemonResponse.self, url, .GET) { result in
      print("result \(result)")
    }
  }
}

private extension PokemonListService {
  struct PokemonResponse: Codable {
    var next: String
    var results: Array<Pokemon>
  }
}
