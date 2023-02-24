//
//  HttpRequest.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import Foundation

protocol HttpRequest {
  var host: String { get }
  var path: String { get }
  var method: HttpMethod { get }
  var queryItems: [String:String]? { get }
}

extension HttpRequest {
  var queryItems: [String:String]? { nil }
  
  var url: URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = path
    
    var requestQueryItems = [URLQueryItem]()
    
    queryItems?.forEach { item in
      requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
    }
    
#if DEBUG
    requestQueryItems.append(URLQueryItem(name: "delay", value: "2"))
#endif
    
    urlComponents.queryItems = requestQueryItems
    
    return urlComponents.url
  }
}
