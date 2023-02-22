//
//  PokemonListViewController.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonListViewController: UIViewController {
  var viewModel: PokemonListViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetchList()
  }
}
