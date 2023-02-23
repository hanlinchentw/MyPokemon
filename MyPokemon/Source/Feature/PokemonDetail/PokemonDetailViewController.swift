//
//  PokemonDetailViewController.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonDetailViewController: UIViewController {
  var viewModel: (any PokemonDetailViewModelImpl)!
  var detailView: PokemonDetailView!

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetch()
    setupUI()
    setupNavbar()
  }
}

extension PokemonDetailViewController {
  func setupUI() {
    detailView = PokemonDetailView()
    detailView.frame = view.bounds
    view.addSubview(detailView)
  }
  
  func setupNavbar() {
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.prefersLargeTitles = false
  }
}

extension PokemonDetailViewController: PokemonDetailViewInput {
  func update() {
    DispatchQueue.main.async {
      self.detailView.pokemonDetail = self.viewModel.detail
    }
  }
}
