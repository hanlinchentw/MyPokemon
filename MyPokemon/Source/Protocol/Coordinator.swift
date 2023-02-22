//
//  Coordinator.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol Coordinator: class {
  var coordinators: [Coordinator] { get set }
}

extension Coordinator {
  func addCoordinator(_ coordinator: Coordinator) {
    coordinators.append(coordinator)
  }
  
  func removeCoordinator(_ coordinator: Coordinator) {
    coordinators = coordinators.filter { $0 !== coordinator }
  }
  
  func removeAllCoordinators() {
    coordinators.removeAll()
  }
}
