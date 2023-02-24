//
//  GetPokemonsRequest.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

struct GetPokemonRequest: HttpRequest {
  var offset: Int
  var limit: Int
  
  init(offset: Int = 0, limit: Int = 20) {
    self.offset = offset
    self.limit = limit
  }

  var host: String { Constants.POKEMON_SERVER_HOST }
  var path: String { "/api/v2/pokemon" }
  var method: HttpMethod { .GET }
  var queryItems: [String : String]? {
    [
      "offset": "\(offset)",
      "limit": "\(limit)"
    ]
  }
}
