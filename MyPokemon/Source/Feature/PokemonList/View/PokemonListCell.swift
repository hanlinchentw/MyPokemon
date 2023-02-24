//
//  PokemonListCell.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

protocol PokemonListCellDelegate: AnyObject {
  func didTapCaptureButton(pokemon: Pokemon, isCapture: Bool)
}

class PokemonListCell: UICollectionViewCell {
  weak var delegate: PokemonListCellDelegate?
  
  var viewModel: PokemonListItemViewModel? {
    didSet {
      configureCell()
    }
  }
  
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
  
  private lazy var captureButton: UIButton = {
    let button = UIButton()
    button.tintColor = .red
    button.addTarget(self, action: #selector(handleCaptureBtnTapped), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 16
    
    contentView.addSubview(captureButton)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(chevronImageView)
    contentView.addSubview(stackView)
    
    captureButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      captureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      captureButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
      captureButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
      captureButton.widthAnchor.constraint(equalToConstant: 44),
      captureButton.widthAnchor.constraint(equalToConstant: 44)
    ])
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: captureButton.trailingAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.titleLabel.text = ""
    captureButton.setImage(nil, for: .normal)
  }
  
  func configureCell() {
    guard let vm = viewModel else {
      self.titleLabel.text = "Failed to load ..."
      return
    }
    self.titleLabel.text = vm.name.capitalized
    
    if vm.isCapture {
      captureButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
    } else {
      captureButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
    }
  }
  
  @objc func handleCaptureBtnTapped() {
    guard let vm = viewModel else {
      return
    }
    delegate?.didTapCaptureButton(pokemon: vm.pokemon, isCapture: vm.isCapture)
  }
}
