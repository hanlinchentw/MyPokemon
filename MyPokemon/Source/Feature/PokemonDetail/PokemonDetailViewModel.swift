//
//  PokemonDetailViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol PokemonDetailViewModelImpl {
  
}

class PokemonDetailViewModel: PokemonDetailViewModelImpl {
  let apiService: PokemonDetailServiceImpl

  init(apiService: PokemonDetailServiceImpl) {
    self.apiService = apiService
  }
}
