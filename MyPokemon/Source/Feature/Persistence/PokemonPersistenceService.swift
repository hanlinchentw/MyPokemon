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
  func release(_ name: String)
}

protocol PokemonPersistenceServiceDelegate: AnyObject {
  func onDataChanged(_ change: Array<RLM_Pokemon>)
}

class PokemonPersistenceService: PokemonPersistenceServiceImpl {
  
  weak var delegate: PokemonPersistenceServiceDelegate?
  var manager: PersistenceManagerImpl
  
  var notificationToken: NotificationToken?
  
  init(manager: PersistenceManagerImpl = PersistenceManager.shared) {
    self.manager = manager
    observePersistenceChange()
  }
  
  func capture(_ pokemon: Pokemon) {
    let rlm_pokemon = RLM_Pokemon(id: pokemon.id, name: pokemon.name, detailUrl: pokemon.detailUrl)
    manager.add(rlm_pokemon, update: true)
  }

  func release(_ name: String) {
    let predicate = NSPredicate(format: "name==%@", name)
    if let object = manager.objects(RLM_Pokemon.self, predicate: predicate)?.first {
      manager.delete(object)
    }
  }
  
  func observePersistenceChange() {
    let pokemons = manager.getRealm().objects(RLM_Pokemon.self)
    
    notificationToken = pokemons.observe() { [weak self] change in
      switch change {
      case .initial(let pokemons), .update(let pokemons, _, _, _):
        self?.delegate?.onDataChanged(pokemons.map { $0 })
      case .error(let error):
        print("persistence change error=\(error.localizedDescription)")
      }
    }
  }
}
