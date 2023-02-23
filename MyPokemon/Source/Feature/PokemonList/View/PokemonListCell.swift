//
//  PokemonListCell.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PokemonListCell: UICollectionViewCell {

  private let stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.spacing = 10
      stackView.alignment = .center
      return stackView
  }()
  
  private let titleLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont(name: "Arial", size: 20)
      label.textColor = .black
      return label
  }()
  
  private let chevronImageView: UIImageView = {
      let iv = UIImageView()
      iv.image = UIImage(systemName: "chevron.right")
      iv.tintColor = .black
      return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 16

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(chevronImageView)
    contentView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(_ vm: PokemonListItemViewModel) {
    self.titleLabel.text = vm.name.capitalized
  }
}
