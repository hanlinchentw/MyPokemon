//
//  IndicatorCell.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit


class IndicatorCell: UICollectionViewCell {
  
  var indicator : UIActivityIndicatorView = {
    let view = UIActivityIndicatorView()
    view.style = .large
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(indicator)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func start() {
    indicator.startAnimating()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    indicator.stopAnimating()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
