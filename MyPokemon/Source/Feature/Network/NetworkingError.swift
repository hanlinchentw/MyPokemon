//
//  NetworkingError.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/25.
//

import Foundation

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

extension NetworkingManager.NetworkingError: Equatable {
  static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
    switch(lhs, rhs) {
    case (.invalidUrl, .invalidUrl):
      return true
    case (.custom(let lhsType), .custom(let rhsType)):
      return lhsType.localizedDescription == rhsType.localizedDescription
    case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
      return lhsType == rhsType
    case (.invalidData, .invalidData), (.invalidResponse, .invalidResponse),(.failedToDecode, .failedToDecode):
      return true
    default:
      return false
    }
  }
}

extension NetworkingManager.NetworkingError {
  var errorDescription: String? {
    switch self {
    case .invalidUrl:
      return "URL isn't valid"
    case .invalidStatusCode:
      return "Status code falls into the wrong range"
    case .invalidData, .invalidResponse:
      return "Response data is invalid"
    case .failedToDecode:
      return "Failed to decode"
    case .custom(let err):
      return "Something went wrong \(err.localizedDescription)"
    }
  }
}
