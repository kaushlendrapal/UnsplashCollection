//
//  RequestHelper.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestHelper {
    var baseURL: String { get }
    var requestURL: URLRequest! { get }
    var requestBody: Any? { get }
    var requestHeader: [String: String]? { get }
    var requestType: RequestType { get }
    
}


extension RequestHelper {
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var requestType: RequestType {
        return .get
    }
    
    var requestHeader: [String: String] {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
    
}

// MARK: - URL extension

extension URL {
    
    func appending(queryItems: [URLQueryItem]) -> URL {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        
        var queryDictionary = [String: String]()
        if let queryItems = components.queryItems {
            for item in queryItems {
                queryDictionary[item.name] = item.value
            }
        }
        
        for item in queryItems {
            queryDictionary[item.name] = item.value
        }
        var newComponents = components
        newComponents.queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })
        return newComponents.url ?? self
    }
    
}

// MARK: - Int extension

extension Int {
    var megabytes: Int { return self * 1024 * 1024 }
}
