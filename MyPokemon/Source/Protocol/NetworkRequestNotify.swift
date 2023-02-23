//
//  NetworkRequestNotify.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol NetworkRequestNotify: AnyObject {
  associatedtype Response
  func onHandleFetchResult(_ result: Result<Response, Error>)
}
