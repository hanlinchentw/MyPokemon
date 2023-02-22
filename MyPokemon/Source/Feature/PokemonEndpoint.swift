//
//  EndPoint.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

enum PokemonEndpoint {
  case pokemons
  case detail(String)
}

extension PokemonEndpoint {
  var host: String { "pokeapi.co"}

  var path: String {
    switch self {
    case .pokemons:
      return "/api/v2/pokemon"
    case .detail(let id):
      return "/api/v2/pokemon/\(id)"
    }
  }
  
  var methodType: HttpMethod {
    switch self {
    case .pokemons, .detail:
      return .GET
    }
  }
  
  var queryItems: [String: String]? {
    return nil
  }

  var url: URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = path
    
    var requestQueryItems = [URLQueryItem]()
    
    queryItems?.forEach { item in
      requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
    }
    
#if DEBUG
    requestQueryItems.append(URLQueryItem(name: "delay", value: "2"))
#endif
    
    urlComponents.queryItems = requestQueryItems
    
    return urlComponents.url
  }
}
