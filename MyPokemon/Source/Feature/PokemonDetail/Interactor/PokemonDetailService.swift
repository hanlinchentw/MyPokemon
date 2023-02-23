//
//  PokemonDetailService.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol PokemonDetailServiceImpl {
  func load(_ urlString: String)
}

protocol PokemonDetailViewModelInput: AnyObject {
  func onFetchCompletd(_ result: PokemonDetailService.PokemonDetailResponse)
  func onFetchFailed(_ result: Error)
}


class PokemonDetailService: PokemonDetailServiceImpl, NetworkRequestNotify {
  weak var delegate: (any PokemonDetailViewModelInput)?
  typealias Response = PokemonDetailResponse
  
  
  func load(_ urlString: String) {
    let url = URL(string: urlString)
    NetworkingManager.shared.request(type: Response.self, url, .GET) { [weak self] result in
      self?.onHandleFetchResult(result)
    }
  }
  
  func onHandleFetchResult(_ result: Result<Response, Error>) {
    switch result {
    case .success(let response):
      delegate?.onFetchCompletd(response)
    case .failure(let error):
      delegate?.onFetchFailed(error)
    }
  }
}

extension PokemonDetailService {
  struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprite
    let types: Array<PokemonTypeSlot>
  }

  struct Sprite: Codable {
    let imageUrl: String
    enum CodingKeys: String, CodingKey {
      case imageUrl = "front_default"
    }
  }
  
  struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
  }
  
  struct PokemonType: Codable {
    let name: String
  }
}
