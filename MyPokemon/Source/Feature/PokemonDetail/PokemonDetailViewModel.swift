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

  init(pokemon: Pokemon, apiService: PokemonDetailServiceImpl) {
    self.apiService = apiService
    self.pokemon = pokemon
  }
  
  func fetch() {
    apiService.load(pokemon.url)
  }
}

extension PokemonDetailViewModel: PokemonDetailViewModelInput {
  func onFetchCompletd(_ result: PokemonDetailService.PokemonDetailResponse) {
    print("onFetchCompletd=\(result)")
    let detail = PokemonDetail(id: result.id, name: result.name, height: result.height, weight: result.weight, imageUrl: result.sprites.imageUrl)
    self.detail = detail
  }
  
  func onFetchFailed(_ result: Error) {
    print("onFetchFailed=\(result.localizedDescription)")
  }
}
