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
  let pocketButton = UIButton(type: .custom)
  
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
  func updateFetchState() {
    DispatchQueue.main.async {
      let label = UILabel()
      label.text = self.viewModel.fetchingState?.rawValue
      label.font = UIFont.systemFont(ofSize: 17.0)
      label.textColor = self.viewModel.fetchingState == PokemonListFetchState.apiError ? .red : .white
      let barButton = UIBarButtonItem(customView: label)
      self.navigationItem.rightBarButtonItem = barButton
    }
  }
  
  func refresh() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  func onPocketChange() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
      let zoomAnimation = CGAffineTransform(scaleX: 1.2, y: 1.2)
      UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
        self.pocketButton.transform = zoomAnimation
      } completion: { (_) in
        UIView.animate(withDuration: 0.4, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut) {
          self.pocketButton.transform = zoomAnimation.inverted()
        }
      }
    }
  }
}

extension PokemonListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.numberOfRows(in: section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if viewModel.cellShouldLoading(for: indexPath) {
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
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: viewModel.cellShouldLoading) {
      viewModel.fetchList()
    }
  }
}

extension PokemonListViewController: PokemonListCellDelegate {
  func didTapCaptureButton(pokemon: Pokemon, isCapture: Bool) {
    viewModel.didTapBtn(pokemon, isCapture)
  }
}

// MARK: - Setup UI
extension PokemonListViewController {
  private func setupUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    pocketButton.setImage(UIImage(named: "icon_back_bag"), for: .normal)
    
    pocketButton.tintColor = .systemRed
    pocketButton.backgroundColor = .white
    pocketButton.layer.cornerRadius = 30
    pocketButton.translatesAutoresizingMaskIntoConstraints = false
    pocketButton.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
    pocketButton.addShadow()
    
    self.view.addSubview(pocketButton)
    
    NSLayoutConstraint.activate([
      pocketButton.widthAnchor.constraint(equalToConstant: 60),
      pocketButton.heightAnchor.constraint(equalToConstant: 60),
      pocketButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      pocketButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  @objc private func handleButtonTap(_ sender: UIButton) {
    coordinator.navigateToPocket()
  }
}
