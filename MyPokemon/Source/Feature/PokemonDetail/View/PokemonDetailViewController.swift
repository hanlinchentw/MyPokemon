//
//  PokemonDetailViewController.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonDetailViewController: UIViewController {
  var captureButton = UIButton()
  var viewModel: PokemonDetailViewModel!
  var detailView: PokemonDetailView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetch()
    setupUI()
    setupNavbar()
    setupPocketBtn()
  }
}

extension PokemonDetailViewController {
  func setupUI() {
    detailView = PokemonDetailView()
    detailView!.frame = view.bounds
    view.addSubview(detailView!)
  }
  
  func setupNavbar() {
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.prefersLargeTitles = false
  }
}

extension PokemonDetailViewController: PokemonDetailViewInput {
  func update() {
    DispatchQueue.main.async {
      self.detailView?.pokemonDetail = self.viewModel.detail
      if self.viewModel.isCaptured {
        self.captureButton.setImage(UIImage(named: "icon_pokemon_ball_fill"), for: .normal)
      } else {
        self.captureButton.setImage(UIImage(named: "icon_pokemon_ball_default"), for: .normal)
      }
    }
  }
  
  func onError(_ error: Error?) {
    let alertVC = UIAlertController(title: "Network error", message: "Something went wrong when we want to fetch data remotely ...\n, error=\(error?.localizedDescription)", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel)
    alertVC.addAction(action)
    self.present(alertVC, animated: true)
  }
}

extension PokemonDetailViewController {
  func setupPocketBtn() {
    captureButton.backgroundColor = .white
    captureButton.layer.cornerRadius = 30
    captureButton.translatesAutoresizingMaskIntoConstraints = false
    captureButton.addTarget(self, action: #selector(handleBtnTap), for: .touchUpInside)
    captureButton.addShadow()
    
    view.addSubview(captureButton)
    
    NSLayoutConstraint.activate([
      captureButton.widthAnchor.constraint(equalToConstant: 60),
      captureButton.heightAnchor.constraint(equalToConstant: 60),
      captureButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      captureButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  @objc func handleBtnTap() {
    viewModel.didTapBtn()
  }
}
