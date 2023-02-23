//
//  PokemonDetailView.swift
//  MyPokemon
//
//  Created by Leo Chen on 2023/2/23.
//

import UIKit
import Kingfisher

class PokemonDetailView: UIView {
  
  // 資料來源
  var pokemonDetail: PokemonDetail? {
    didSet {
      configureData()
    }
  }
  
  // UI 元件
  let idLabel = UILabel()
  let nameLabel = UILabel()
  let heightLabel = UILabel()
  let weightLabel = UILabel()
  let imageView = UIImageView()
  
  // 初始化
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 設定 UI 元件
  func setupUI() {
    backgroundColor = .black
    
    // Pokemon ID Label
    idLabel.translatesAutoresizingMaskIntoConstraints = false
    idLabel.textAlignment = .center
    idLabel.font = UIFont.boldSystemFont(ofSize: 24)
    addSubview(idLabel)
    
    NSLayoutConstraint.activate([
      idLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
      idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      idLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      idLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    // Pokemon 名稱 Label
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.textAlignment = .center
    nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
    addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      nameLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    // Pokemon 高度 Label
    heightLabel.translatesAutoresizingMaskIntoConstraints = false
    heightLabel.textAlignment = .center
    addSubview(heightLabel)
    
    NSLayoutConstraint.activate([
      heightLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
      heightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      heightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      heightLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    // Pokemon 體重 Label
    weightLabel.translatesAutoresizingMaskIntoConstraints = false
    weightLabel.textAlignment = .center
    addSubview(weightLabel)
    
    NSLayoutConstraint.activate([
      weightLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 20),
      weightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      weightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      weightLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    // Pokemon 圖片 ImageView
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 20),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    ])
  }
  
  // 設定資料
  func configureData() {
    guard let pokemon = pokemonDetail else { return }
    idLabel.text = "Pokemon ID: \(pokemon.id)"
    nameLabel.text = pokemon.name
    heightLabel.text = "Height: \(pokemon.height)"
    weightLabel.text = "Weight: \(pokemon.weight)"
    
    guard let imageUrl = URL(string: pokemon.imageUrl) else {
      return
    }
    imageView.kf.setImage(with: imageUrl)
  }
}
