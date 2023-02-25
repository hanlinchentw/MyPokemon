//
//  PokemonListServiceSuccessMock.swift
//  MyPokemonTests
//
//  Created by 陳翰霖 on 2023/2/25.
//

import Foundation
@testable import MyPokemon

class PokemonListServiceSuccessMock: PokemonListServiceImpl {
  weak var delegate: PokemonListServiceDelegate?
  
  func loadMore() {
    let pokemonNames = ["Pikachu", "Charmander", "Squirtle", "Bulbasaur", "Jigglypuff", "Eevee", "Snorlax", "Mewtwo", "Gyarados", "Dragonite", "Magikarp", "Psyduck", "Gengar", "Lapras", "Vaporeon", "Flareon", "Jolteon", "Espeon", "Umbreon", "Leafeon"]
    
    var pokemonArray: [Pokemon] = []
    
    for i in 1...pokemonNames.count {
      let randomIndex = Int.random(in: 0..<pokemonNames.count)
      let name = pokemonNames[randomIndex]
      let detailUrl = "https://pokeapi.co/api/v2/pokemon/\(i)"
      let pokemon = Pokemon(name: name, detailUrl: detailUrl)
      pokemonArray.append(pokemon)
    }
    
    delegate?.onFetchCompletd(pokemonArray, hasReachEnd: false)
  }
}
