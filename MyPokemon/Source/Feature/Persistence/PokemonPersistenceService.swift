//
//  PokemonPersistenceService.swift
//  MyPokemon
//
//  Created by Leo Chen on 2023/2/24.
//

import Foundation
import RealmSwift

protocol PokemonPersistenceServiceImpl {
  func capture(_ pokemon: Pokemon)
  func release(_ pokemon: Pokemon)
}

class PokemonPersistenceService: PokemonPersistenceServiceImpl {
  var manager: PersistenceManagerImpl
  
  init(manager: PersistenceManagerImpl = PersistenceManager.shared) {
    self.manager = manager
  }
  
  func capture(_ pokemon: Pokemon) {
    let rlm_pokemon = RLM_Pokemon(name: pokemon.name)
    manager.add(rlm_pokemon, update: true)
    
    let token = rlm_pokemon.observe { change in
      print("rlm_pokemon change=\(change)")
    }
    token.invalidate()
  }
  
  func release(_ pokemon: Pokemon) {
    let rlm_pokemon = RLM_Pokemon(name: pokemon.name)
    manager.delete(rlm_pokemon)
    
    let token = rlm_pokemon.observe { change in
      print("rlm_pokemon change=\(change)")
    }
    token.invalidate()
  }
  
  func observePersistenceChange() {
    
  }
}
