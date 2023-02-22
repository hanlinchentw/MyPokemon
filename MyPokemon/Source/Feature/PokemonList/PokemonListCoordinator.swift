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
		let pokemonListVC = PokemonListViewController()
		navigationController.setViewControllers([pokemonListVC], animated: false)
	}
}
