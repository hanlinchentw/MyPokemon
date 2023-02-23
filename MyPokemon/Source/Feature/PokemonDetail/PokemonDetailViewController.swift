//
//  PokemonDetailViewController.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonDetailViewController: UIViewController {
  var viewModel: (any PokemonDetailViewModelImpl)!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetch()
  }
}

extension PokemonDetailViewController: PokemonDetailViewInput {
  func update() {
    print("PokemonDetailViewController=\(viewModel.detail)")
  }
}
