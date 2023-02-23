//
//  PokemonListViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol PokemonListViewModelImpl {
  func fetchList()
}

protocol PokemonListViewModelDelegate: AnyObject {
  func refresh()
}

class PokemonListViewModel: PokemonListViewModelImpl {
  private var isFetchInProgress = false
  
  let apiService: PokemonListServiceImpl
  
  weak var delegate: PokemonListViewModelDelegate?
  
  var sections: [PokemonListItemViewModel] = [] {
    didSet {
      DispatchQueue.main.async {
        self.delegate?.refresh()
      }
    }
  }
  
  init(apiService: PokemonListServiceImpl) {
    self.apiService = apiService
  }
  
  func fetchList() {
    guard !isFetchInProgress else {
      return
    }
    isFetchInProgress = true
    apiService.loadMore()
  }
  
  func fetchMore() {
    apiService.loadMore()
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
    self.sections += result.compactMap({ pokemon in
      PokemonListItemViewModel(pokemon: pokemon)
    })
    self.isFetchInProgress = false
  }
  
  func onFetchFailed(_ result: Error) {
    self.isFetchInProgress = false
  }
}
