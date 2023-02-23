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
    let viewModel = PocketViewModel()
    let pocketVC = PocketViewController()
    
    pocketVC.viewModel = viewModel
    viewModel.viewInput = pocketVC

    navigationController.present(pocketVC, animated: true)
  }
}

