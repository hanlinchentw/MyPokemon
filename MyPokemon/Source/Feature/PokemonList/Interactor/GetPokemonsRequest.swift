//
//  GetPokemonsRequest.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

struct GetPokemonRequest: HttpRequest {
  var host: String { Constants.POKEMON_SERVER_HOST }
  var path: String { "/api/v2/pokemon" }
  var method: HttpMethod { .GET }
  var queryItem: [String : String]? { nil }
}
