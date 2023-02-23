//
//  PokemonListCell.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonListCell: UICollectionViewCell {
  static let reuseIdentifier = "PokemonListCell"

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32)
    label.text = "test"
    label.textColor = .black
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 16

    titleLabel.frame = bounds
    addSubview(titleLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(_ vm: PokemonListItemViewModel) {
    print("cell: \(vm.name)")
    self.titleLabel.text = vm.name
  }
}
