//
//  PokemonListViewController.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonListViewController: UIViewController {
  // MARK: - Property
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    collectionView.backgroundColor = .white
    collectionView.register(PokemonListCell.self, forCellWithReuseIdentifier: PokemonListCell.reuseIdentifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  var bottomConstraint: NSLayoutConstraint?
  
  var viewModel: PokemonListViewModel!
  var coordinator: PokemonListCoodinator!
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
    viewModel.fetchList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationController()
  }
}
// MARK: - Setup UI
extension PokemonListViewController {
  private func setupUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(collectionView)
    
    bottomConstraint = collectionView.bottomAnchor
      .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      bottomConstraint!
    ])
  }
  
  private func setupNavigationController() {
    self.navigationItem.title = "Pokemon"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    
    if let navigationController = navigationController {
      if #available(iOS 15.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [
          .foregroundColor: UIColor.white // 設定大標題的文字顏色
        ]
        appearance.backgroundColor = .black
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
      } else {
        navigationController.navigationBar.largeTitleTextAttributes = [
          .foregroundColor: UIColor.white // 設定大標題的文字顏色
        ]
        navigationController.navigationBar.backgroundColor = .black
      }
    }
    
  }
  
  private func collectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 250, height: 100)
    return layout
  }
}

extension PokemonListViewController: PokemonListViewModelDelegate {
  func refresh() {
    collectionView.reloadData()
  }
}

extension PokemonListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.numberOfRows(in: section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonListCell.reuseIdentifier, for: indexPath) as! PokemonListCell
    let vm = viewModel.cellViewModel(for: indexPath)
    cell.configureCell(vm)
    return cell
  }
}

extension PokemonListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vm = viewModel.cellViewModel(for: indexPath)
    coordinator.navigateToDetail(vm.pokemon)
  }
}
