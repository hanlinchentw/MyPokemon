//
//  UIView+Extensions.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/24.
//

import UIKit

extension UIView {
  func addShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 4
    layer.masksToBounds = false
  }
}
