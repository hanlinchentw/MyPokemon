//
//  NetworkManager.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol NetworkingManagerImpl {
  func request<T: Codable>(type: T.Type, session: URLSession, _ url: URL?, _ method: HttpMethod, useCache: Bool, completion: @escaping(Result<T, Error>) -> Void)
}

final class NetworkingManager: NetworkingManagerImpl {
  
  static let shared = NetworkingManager()
  
  private init() {
    URLCache.shared.diskCapacity = 50 * 1024 * 1024 // 50 MB
    URLCache.shared.memoryCapacity = 10 * 1024 * 1024 // 10 MB
  }

  func request<T: Codable>(type: T.Type, session: URLSession = .shared, _ url: URL?, _ method: HttpMethod, useCache: Bool = true, completion: @escaping(Result<T, Error>) -> Void) {
    guard let url = url else {
      completion(.failure(NetworkingError.invalidUrl))
      return
    }
    
    let request = buildRequest(from: url, methodType: method)
    
    if useCache, let cacheData = URLCache.shared.cachedResponse(for: request) {
      guard let res: T = try? self.decodeResponse(cacheData.data) else {
        completion(.failure(NetworkingError.failedToDecode))
        return
      }
      completion(.success(res))
      return
    }
    
    let task = session.dataTask(with: request) { data, response, error in
      guard let response = response as? HTTPURLResponse else {
        completion(.failure(NetworkingError.invalidResponse))
        return
      }
      guard (200...300) ~= response.statusCode else {
        completion(.failure(NetworkingError.invalidStatusCode(statusCode: response.statusCode)))
        return
      }
      guard let data = data else {
        completion(.failure(NetworkingError.invalidData))
        return
      }
      
      if useCache {
        let expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24) // 1 day
        let cachedResponse = CachedURLResponse(response: response, data: data, userInfo: ["ExpirationDate": expirationDate.timeIntervalSince1970], storagePolicy: .allowed)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
      }

      guard let res: T = try? self.decodeResponse(data) else {
        completion(.failure(NetworkingError.failedToDecode))
        return
      }
      completion(.success(res))
    }
    task.resume()
  }
  
  func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
    let decoder = JSONDecoder()
    let res = try decoder.decode(T.self, from: data)
    return res
  }
}


private extension NetworkingManager {
  func buildRequest(from url: URL, methodType: HttpMethod) -> URLRequest {
    var request = URLRequest(url: url)
    switch methodType {
    case .GET:
      request.httpMethod = "GET"
    case .POST(let data):
      request.httpMethod = "POST"
      request.httpBody = data
    }
    return request
  }
}
