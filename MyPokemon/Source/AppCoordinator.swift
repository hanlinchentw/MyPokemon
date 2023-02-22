//
//  AppCoordinator.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class AppCoordinator: Coordinator {
  var coordinators: [Coordinator] = []
  
  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  
  func start() {
    let pokemonListCoordinator = PokemonListCoodinator(navigationController: navigationController)
    pokemonListCoordinator.start()
    addCoordinator(pokemonListCoordinator)
  }
}
