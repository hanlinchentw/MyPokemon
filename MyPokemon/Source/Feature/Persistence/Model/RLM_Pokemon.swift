//
//  Pokemon.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation
import RealmSwift

class RLM_Pokemon: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var name: String
  @Persisted var detailUrl: String
  
  convenience init(id: String, name: String, detailUrl: String) {
    self.init()
    self.id = id
    self.name = name
    self.detailUrl = detailUrl
  }
}
