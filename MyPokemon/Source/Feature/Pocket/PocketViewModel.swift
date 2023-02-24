//
//  PocketViewModel.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/24.
//

import Foundation

protocol PocketViewModelImpl {
  var data: Array<RLM_Pokemon> { get set }
  func fetch()
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

  func fetch() {
    let pokemon1 = RLM_Pokemon()
    pokemon1.id = 1
    pokemon1.name = "Bulbasaur"
    pokemon1.imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"

    let pokemon2 = RLM_Pokemon()
    pokemon2.id = 2
    pokemon2.name = "Charmander"
    pokemon2.imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"

    let pokemon3 = RLM_Pokemon()
    pokemon3.id = 3
    pokemon3.name = "Squirtle"
    pokemon3.imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png"
    
    self.data = [pokemon1, pokemon2, pokemon3]
  }
}
