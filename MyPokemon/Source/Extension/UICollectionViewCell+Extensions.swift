//
//  UICollectionViewCell+Extensions.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

extension UICollectionViewCell {
  static var reuseIdentifier: String {
    return NSStringFromClass(self)
  }
}
