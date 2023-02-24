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
    collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCell.reuseIdentifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.prefetchDataSource = self
    return collectionView
  }()
  var bottomConstraint: NSLayoutConstraint?
  
  var viewModel: PokemonListViewModel!
  var coordinator: PokemonListCoodinator!
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupPocketBtn()
    viewModel.fetchList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationController()
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
    if cellShouldLoading(for: indexPath) {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.reuseIdentifier, for: indexPath) as! IndicatorCell
      cell.start()
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonListCell.reuseIdentifier, for: indexPath) as! PokemonListCell
    cell.viewModel = viewModel.cellViewModel(for: indexPath)
    cell.delegate = self
    return cell
  }
}

extension PokemonListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vm = viewModel.cellViewModel(for: indexPath)
    coordinator.navigateToDetail(vm.pokemon)
  }
}

extension PokemonListViewController: UICollectionViewDataSourcePrefetching {
  func cellShouldLoading(for indexPath: IndexPath) -> Bool {
    indexPath.row + 1 >= viewModel.numberOfRows(in: indexPath.section)
  }
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: cellShouldLoading) {
      viewModel.fetchList()
    }
  }
}

extension PokemonListViewController: PokemonListCellDelegate {
  func didTapCaptureButton(_ pokemon: Pokemon) {
    viewModel.capture(pokemon)
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
        appearance.titleTextAttributes = [
          .foregroundColor: UIColor.white
        ]
        appearance.backgroundColor = .black
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
      } else {
        navigationController.navigationBar.largeTitleTextAttributes = [
          .foregroundColor: UIColor.white // 設定大標題的文字顏色
        ]
        navigationController.navigationBar.titleTextAttributes = [
          .foregroundColor: UIColor.white
        ]
        navigationController.navigationBar.backgroundColor = .black
      }
    }
  }
  
  private func collectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 360, height: 120)
    return layout
  }
}

extension PokemonListViewController {
  func setupPocketBtn() {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
    button.tintColor = .systemRed
    button.backgroundColor = .white
    button.layer.cornerRadius = 30
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
    button.addShadow()

    self.view.addSubview(button)

    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 60),
        button.heightAnchor.constraint(equalToConstant: 60),
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  @objc private func handleButtonTap(_ sender: UIButton) {
    coordinator.navigateToPocket()
  }
}
