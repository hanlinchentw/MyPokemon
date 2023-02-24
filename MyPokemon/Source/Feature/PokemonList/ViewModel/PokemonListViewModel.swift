//
//  PokemonListViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation
import RealmSwift

protocol PokemonListViewModelImpl {
  func fetchList()
}

protocol PokemonListViewModelDelegate: AnyObject {
  func refresh()
}

class PokemonListViewModel: PokemonListViewModelImpl {
  var isFetching = false
  
  let apiService: PokemonListServiceImpl
  let persistenceService: PokemonPersistenceServiceImpl
  
  weak var delegate: PokemonListViewModelDelegate?
  
  var sections: [PokemonListItemViewModel] = [] {
    didSet {
      DispatchQueue.main.async {
        self.delegate?.refresh()
      }
    }
  }
  
  init(apiService: PokemonListServiceImpl, persistenceService: PokemonPersistenceServiceImpl) {
    self.apiService = apiService
    self.persistenceService = persistenceService
  }
  
  func fetchList() {
    guard !isFetching else {
      return
    }
    isFetching = true
    apiService.loadMore()
  }
  
  func capture(_ pokemon: Pokemon) {
    persistenceService.capture(pokemon)
  }
  
  var numberOfSection: Int {
    return 1
  }
  
  func numberOfRows(in section: Int) -> Int {
    return sections.count
  }
  
  func cellViewModel(for indexPath: IndexPath) -> PokemonListItemViewModel {
    return sections[indexPath.row]
  }
}

extension PokemonListViewModel: PokemonListViewModelInput {
  func onFetchCompletd(_ result: Array<Pokemon>) {
    DispatchQueue.main.async {
      self.sections += result.compactMap({ pokemon in
        PokemonListItemViewModel(pokemon: pokemon)
      })
      self.isFetching = false
    }
  }
  
  func onFetchFailed(_ result: Error) {
    DispatchQueue.main.async {
      self.isFetching = false
    }
  }
}
