//
//  NetworkManager.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol NetworkingManagerImpl {
  func request<T: Codable>(type: T.Type, _ url: URL?, _ method: HttpMethod, completion: @escaping(Result<T, Error>) -> Void)
  func request<T: Codable>(type: T.Type, _ request: HttpRequest, completion: @escaping(Result<T, Error>) -> Void)
}

final class NetworkingManager: NetworkingManagerImpl {
  
  static let shared = NetworkingManager()
  
  private init() {}
  
  func request<T: Codable>(type: T.Type,_ request: HttpRequest, completion: @escaping(Result<T, Error>) -> Void) {
    guard let url = request.url else {
      completion(.failure(NetworkingError.invalidUrl))
      return
    }
    
    let request = buildRequest(from: url, methodType: request.method)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      guard let res = try? decoder.decode(T.self, from: data) else {
        completion(.failure(NetworkingError.failedToDecode))
        return
      }
      completion(.success(res))
    }
    task.resume()
  }
  
  func request<T: Codable>(type: T.Type, _ url: URL?, _ method: HttpMethod, completion: @escaping(Result<T, Error>) -> Void) {
    guard let url = url else {
      completion(.failure(NetworkingError.invalidUrl))
      return
    }
    
    let request = buildRequest(from: url, methodType: method)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
      
      let decoder = JSONDecoder()
      guard let res = try? decoder.decode(T.self, from: data) else {
        completion(.failure(NetworkingError.failedToDecode))
        return
      }
      completion(.success(res))
    }
    task.resume()
  }
}

extension NetworkingManager {
  enum NetworkingError: LocalizedError {
    case invalidUrl
    case custom(error: Error)
    case invalidStatusCode(statusCode: Int)
    case invalidResponse
    case invalidData
    case failedToDecode
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
