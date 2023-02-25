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
  
  var notificationToken: NotificationToken?
  
  var sections: [PokemonListItemViewModel] = [] {
    didSet {
      DispatchQueue.main.async {
        self.delegate?.refresh()
      }
    }
  }
  
  var capturePokemon: Array<Pokemon> = [] {
    didSet {
      refreshState()
    }
  }
  
  init(apiService: PokemonListServiceImpl = PokemonListService(), persistenceService: PokemonPersistenceServiceImpl = PokemonPersistenceService()) {
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
  
  func didTapBtn(_ pokemon: Pokemon, _ isCapture: Bool) {
    if isCapture {
      try? persistenceService.release(pokemon.name)
    } else {
      persistenceService.capture(pokemon)
    }
  }
  
  func refreshState() {
    for index in 0 ..< sections.count {
      let section = sections[index]
      if let _ = capturePokemon.first { $0.name == section.name } {
        self.sections[index].isCapture = true
      } else {
        self.sections[index].isCapture = false
      }
    }
    delegate?.refresh()
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
        let viewModel = PokemonListItemViewModel(pokemon: pokemon)
        if let _ = self.capturePokemon.first(where: { $0.name == viewModel.name }) {
          viewModel.isCapture = true
        }
        return viewModel
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

extension PokemonListViewModel: PokemonPersistenceServiceDelegate {
  func onDataInit(_ initial: Array<RLM_Pokemon>) {
    self.capturePokemon = initial.map { Pokemon(name: $0.name, detailUrl: $0.detailUrl) }
  }
  
  func onDataChanged(_ change: Array<RLM_Pokemon>) {
    self.capturePokemon = change.map { Pokemon(name: $0.name, detailUrl: $0.detailUrl) }
  }
}
