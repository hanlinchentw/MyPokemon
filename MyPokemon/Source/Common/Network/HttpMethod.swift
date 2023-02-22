//
//  HttpMethod.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

enum HttpMethod: Equatable {
  case GET
  case POST(data: Data?)
}
