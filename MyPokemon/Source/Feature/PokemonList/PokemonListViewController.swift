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
    return collectionView
  }()
  var bottomConstraint: NSLayoutConstraint?

  var viewModel: PokemonListViewModel!
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationItem()

    viewModel.fetchList()
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
  
  private func setupNavigationItem() {
    self.navigationItem.title = "Pokemon"
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
