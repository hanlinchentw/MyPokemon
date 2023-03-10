//
//  NetworkmanagerDetailSuccessMock.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import Foundation
@testable import MyPokemon

class NetworkmanagerPokemonDetailSuccessMock: NetworkingManagerImpl {
  func request<T>(type: T.Type, session: URLSession, _ url: URL?, _ method: HttpMethod, useCache: Bool, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
    guard let path = Bundle.main.path(forResource: "PokemonDetailStaticData", ofType: "json"),
          let data = FileManager.default.contents(atPath: path) else {
      fatalError("PokemonDetailStaticData doesn't exist")
    }
    let decoder = JSONDecoder()
    let res = try! decoder.decode(T.self, from: data)
    completion(.success(res))
  }
}
