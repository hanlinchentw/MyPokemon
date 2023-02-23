//
//  Pokemon.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation
import RealmSwift

class RLM_Pokemon: Object {
  @Persisted(primaryKey: true) var id: Int
  @Persisted var name: String
  @Persisted var imageUrl: String?
  
  convenience init(name: String, imageUrl: String? = nil) {
      self.init()
      self.name = name
      self.imageUrl = imageUrl
  }
}
