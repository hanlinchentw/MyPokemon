//
//  PocketCoordinator.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/24.
//

import UIKit

class PocketCoodinator: Coordinator {
  var coordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let persistenceService = PokemonPersistenceService()
    let viewModel = PocketViewModel(persistenceService: persistenceService)
    let pocketVC = PocketViewController()
    
    pocketVC.viewModel = viewModel
    viewModel.viewInput = pocketVC
    persistenceService.delegate = viewModel

    
    let nav = UINavigationController(rootViewController: pocketVC)
    
    navigationController.present(nav, animated: true)
  }
}

