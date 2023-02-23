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
    let viewModel = PokemonDetailViewModel(pokemon: pokemon, apiService: apiService)
    let detailVC = PokemonDetailViewController()
    
    detailVC.viewModel = viewModel
    apiService.delegate = viewModel
    viewModel.viewInput = detailVC
    
    navigationController.pushViewController(detailVC, animated: true)
  }
}
