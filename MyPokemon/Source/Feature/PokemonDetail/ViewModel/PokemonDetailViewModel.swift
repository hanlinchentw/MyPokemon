//
//  PokemonDetailViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol PokemonDetailViewModelImpl {
  var detail: PokemonDetail? { get set }
  func fetch()
}

protocol PokemonDetailViewInput: AnyObject {
  func update()
  func onError(_ error: Error?)
}

class PokemonDetailViewModel: PokemonDetailViewModelImpl {
  weak var viewInput: (any PokemonDetailViewInput)?
  let apiService: PokemonDetailServiceImpl
  
  let pokemon: Pokemon
  
  var detail: PokemonDetail? {
    didSet {
      viewInput?.update()
    }
  }
  
  var error: Error? {
    didSet {
      viewInput?.onError(error)
    }
  }

  init(pokemon: Pokemon, apiService: PokemonDetailServiceImpl) {
    self.apiService = apiService
    self.pokemon = pokemon
  }
  
  func fetch() {
    apiService.load(pokemon.detailUrl)
  }
}

extension PokemonDetailViewModel: PokemonDetailViewModelInput {
  func onFetchCompletd(_ result: PokemonDetailService.PokemonDetailResponse) {
    let types = result.types.map { $0.type.name }
    let detail = PokemonDetail(id: result.id, name: result.name, height: result.height, weight: result.weight, imageUrl: result.sprites.imageUrl, types: types)
    self.detail = detail
  }
  
  func onFetchFailed(_ error: Error) {
    self.error = error
  }
}
