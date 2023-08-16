//
//  Endpoint.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import Foundation

enum Endpoint {
    case main(page: Int)
    case detail(id: Int)
    case location(id: Int)
}

extension Endpoint {
    var host: String { "rickandmortyapi.com" }
    
    var path: String {
        switch self {
        case .main:
            return "/api/character"
        case .detail(let id):
            return "/api/character/\(id)"
        case .location(let id):
            return "/api/location/\(id)"
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .main(let page):
            return ["page":"\(page)"]
        default:
            return nil
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
