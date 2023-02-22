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

class PokemonListViewModel: PokemonListViewModelImpl {
  let apiService: PokemonListServiceImpl

  init(apiService: PokemonListServiceImpl) {
    self.apiService = apiService
  }
  
  func fetchList() {
    apiService.loadMore()
  }
}
