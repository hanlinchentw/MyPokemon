//
//  PocketViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/24.
//

import Foundation

protocol PocketViewModelImpl {
  var data: Array<RLM_Pokemon> { get set }
  func release(_ indexPath: IndexPath)
}

protocol PocketViewInput: AnyObject {
  func onFetchCompleted()
  func onFetchFailed()
}

class PocketViewModel: PocketViewModelImpl {
  weak var viewInput: PocketViewInput?
  
  var data: Array<RLM_Pokemon> = [] {
    didSet {
      viewInput?.onFetchCompleted()
    }
  }
  
  var persistenceService: PokemonPersistenceServiceImpl
  
  init(persistenceService: PokemonPersistenceServiceImpl) {
    self.persistenceService = persistenceService
  }
  
  func release(_ indexPath: IndexPath) {
    let pokemon = data[indexPath.row]
    persistenceService.release(pokemon.name)
  }
}

extension PocketViewModel: PokemonPersistenceServiceDelegate {
  func onDataChanged(_ change: Array<RLM_Pokemon>) {
    self.data = change
  }
}
