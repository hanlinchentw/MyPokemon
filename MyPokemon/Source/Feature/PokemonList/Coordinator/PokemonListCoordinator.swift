//
//  PocketListCoordinator.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonListCoodinator: Coordinator {
  var coordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let apiService = PokemonListService()
    let persistenceService = PokemonPersistenceService()
    let viewModel = PokemonListViewModel(apiService: apiService, persistenceService: persistenceService)
    let pokemonListVC = PokemonListViewController()

    pokemonListVC.viewModel = viewModel
    pokemonListVC.coordinator = self
    apiService.delegate = viewModel
    persistenceService.delegate = viewModel
    viewModel.delegate = pokemonListVC
    
    navigationController.setViewControllers([pokemonListVC], animated: false)
  }
  
  func navigateToDetail(_ pokemon: Pokemon) {
    let detailCoordinator = PokemonDetailCoodinator(navigationController: navigationController)
    detailCoordinator.start(pokemon: pokemon)
  }
  
  func navigateToPocket() {
    let pocketCoordinator = PocketCoodinator(navigationController: navigationController)
    pocketCoordinator.start()
  }
}
