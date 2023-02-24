//
//  PokemonListItemViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

class PokemonListItemViewModel {
  let pokemon: Pokemon

  init(pokemon: Pokemon) {
    self.pokemon = pokemon
  }
  
  var name: String {
    pokemon.name
  }
  
  var isCapture: Bool = false
}
