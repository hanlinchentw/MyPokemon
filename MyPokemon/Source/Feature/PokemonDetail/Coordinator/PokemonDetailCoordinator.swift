//
//  PokemonDetailCoordinator.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonDetailCoodinator: Coordinator {
  var coordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(pokemon: Pokemon) {
    let apiService = PokemonDetailService()
    let persistenceService = PokemonPersistenceService()
    let viewModel = PokemonDetailViewModel(pokemon: pokemon, apiService: apiService, persietenceService: persistenceService)
    let detailVC = PokemonDetailViewController()
    
    detailVC.viewModel = viewModel
    apiService.delegate = viewModel
    viewModel.viewInput = detailVC
    persistenceService.delegate = viewModel
    
    navigationController.pushViewController(detailVC, animated: true)
  }
}
