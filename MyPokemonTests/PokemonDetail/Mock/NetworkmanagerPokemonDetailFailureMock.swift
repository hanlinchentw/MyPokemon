//
//  NetworkmanagerPokemonDetailFailureMock.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import Foundation
@testable import MyPokemon

class NetworkmanagerPokemonDetailFailureMock: NetworkingManagerImpl {
  func request<T>(type: T.Type, session: URLSession, _ url: URL?, _ method: HttpMethod, useCache: Bool, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
    completion(.failure(NetworkingManager.NetworkingError.invalidUrl))
  }
}
