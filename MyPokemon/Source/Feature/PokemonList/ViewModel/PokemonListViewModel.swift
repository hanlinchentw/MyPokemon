//
//  PokemonListViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation
import RealmSwift

enum PokemonListFetchState: String, Equatable {
  case isFetching = "Loading..."
  case hasReachedEnd = "The end"
  case apiError = "Network error"
}

protocol PokemonListViewModelImpl {
  func fetchList()
  var numberOfSection: Int { get }
  var fetchingState: PokemonListFetchState? { get set }
  func numberOfRows(in section: Int) -> Int
  func cellViewModel(for indexPath: IndexPath) -> PokemonListItemViewModel
  func cellShouldLoading(for indexPath: IndexPath) -> Bool
}

protocol PokemonListViewModelDelegate: AnyObject {
  func refresh()
  func updateFetchState()
}

class PokemonListViewModel: PokemonListViewModelImpl {

  let apiService: PokemonListServiceImpl
  let persistenceService: PokemonPersistenceServiceImpl
  
  weak var delegate: PokemonListViewModelDelegate?
  
  private var sections: [PokemonListItemViewModel] = [] { didSet { self.delegate?.refresh() } }
  
  var fetchingState: PokemonListFetchState? { didSet { delegate?.updateFetchState() } }
  
  private var capturedPokemon: Array<Pokemon> = [] { didSet { refreshList() } }
  
  init(apiService: PokemonListServiceImpl = PokemonListService(), persistenceService: PokemonPersistenceServiceImpl = PokemonPersistenceService()) {
    self.apiService = apiService
    self.persistenceService = persistenceService
  }
  
  func fetchList() {
    guard fetchingState != PokemonListFetchState.isFetching || fetchingState != PokemonListFetchState.hasReachedEnd else {
      return
    }
    fetchingState = PokemonListFetchState.isFetching
    apiService.loadMore()
  }
  
  private func refreshList() {
    if sections.isEmpty { return }
    for index in 0 ..< sections.count {
      let section = sections[index]
      if let _ = capturedPokemon.first { $0.name == section.name } {
        self.sections[index].isCapture = true
      } else {
        self.sections[index].isCapture = false
      }
    }
    delegate?.refresh()
  }
  
  
  func didTapBtn(_ pokemon: Pokemon, _ isCapture: Bool) {
    if isCapture {
      // TODO: 可以針對釋放不存在的 Pokemon 顯示錯誤訊息
      try? persistenceService.release(pokemon.name)
    } else {
      persistenceService.capture(pokemon)
    }
  }
  
  // CollectionView data source
  var numberOfSection: Int {
    return 1
  }
  
  func numberOfRows(in section: Int) -> Int {
    return sections.count
  }
  
  func cellViewModel(for indexPath: IndexPath) -> PokemonListItemViewModel {
    return sections[indexPath.row]
  }
  
  func cellShouldLoading(for indexPath: IndexPath) -> Bool {
    fetchingState != PokemonListFetchState.hasReachedEnd && indexPath.row + 1 >= numberOfRows(in: indexPath.section)
  }
}

extension PokemonListViewModel: PokemonListServiceDelegate {
  func onFetchCompletd(_ result: Array<Pokemon>, hasReachedEnd: Bool) {
    DispatchQueue.main.async {
      self.sections += result.compactMap({ pokemon in
        let viewModel = PokemonListItemViewModel(pokemon: pokemon)
        if let _ = self.capturedPokemon.first(where: { $0.name == viewModel.name }) {
          viewModel.isCapture = true
        }
        return viewModel
      })
      self.fetchingState = hasReachedEnd ? PokemonListFetchState.hasReachedEnd : nil
    }
  }
  
  func onFetchFailed(_ error: Error) {
    DispatchQueue.main.async {
      self.fetchingState = PokemonListFetchState.apiError
    }
  }
}

extension PokemonListViewModel: PokemonPersistenceServiceDelegate {
  func onDataInit(_ initial: Array<RLM_Pokemon>) {
    self.capturedPokemon = initial.map { Pokemon(name: $0.name, detailUrl: $0.detailUrl) }
  }
  
  func onDataChanged(_ change: Array<RLM_Pokemon>) {
    self.capturedPokemon = change.map { Pokemon(name: $0.name, detailUrl: $0.detailUrl) }
  }
}
