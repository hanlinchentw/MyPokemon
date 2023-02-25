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
  private let apiService: PokemonDetailServiceImpl
  private let persistenceService: PokemonPersistenceServiceImpl
  
  let pokemon: Pokemon
  
  var detail: PokemonDetail? {
    didSet {
      viewInput?.update()
    }
  }
  
  var isCaptured: Bool = false {
    didSet {
      viewInput?.update()
    }
  }
  
  var error: Error? {
    didSet {
      viewInput?.onError(error)
    }
  }

  init(pokemon: Pokemon, apiService: PokemonDetailServiceImpl, persietenceService: PokemonPersistenceServiceImpl) {
    self.apiService = apiService
    self.persistenceService = persietenceService
    self.pokemon = pokemon
  }
  
  func fetch() {
    apiService.load(pokemon.detailUrl)
  }
  
  func didTapBtn() {
    if isCaptured {
      // TODO: 可以針對釋放不存在的 Pokemon 顯示錯誤訊息
      try? persistenceService.release(pokemon.name)
    } else {
      persistenceService.capture(pokemon)
    }
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

extension PokemonDetailViewModel: PokemonPersistenceServiceDelegate {
  func onDataInit(_ initial: Array<RLM_Pokemon>) {
    isCaptured = initial.contains(where: { $0.name == pokemon.name })
  }
  
  func onDataChanged(_ change: Array<RLM_Pokemon>) {
    isCaptured = change.contains(where: { $0.name == pokemon.name })
  }
}
