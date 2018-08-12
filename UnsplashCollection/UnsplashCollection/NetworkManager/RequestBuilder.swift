//
//  RequestBuilder.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

//MARK: get image request

struct ImageRequestBuilder : RequestHelper {
    var requestURL: URLRequest!
    var requestBody: Any?
    var requestHeader: [String : String]?
    
    var requestType: RequestType?
    
    var baseURL: String {
        return "https://api.unsplash.com/photos"
    }
    
    init() {
    }
    
    mutating func photoURLRequest(withQuery query:String, accessToken: UnsplashAccessToken) {
        guard var components = URLComponents(string: String(baseURL)) else { return }
        components.queryItems = [URLQueryItem(name: "query", value: query)]
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(accessToken.appId!)", forHTTPHeaderField: "Authorization")
        self.requestURL = request
        self.requestType = .get
    }
    
}

//MARK: image Search request

struct ImageSearchRequestBuilder : RequestHelper {
    var requestURL: URLRequest!
    var requestBody: Any?
    var requestHeader: [String : String]?
    var baseURL: String {
        return "https://api.unsplash.com/search/photos"
    }
    var requestType: RequestType?
    
    init() {
        
    }
    
    mutating func photoListRequest(withQuery query:[String: Any], accessToken: UnsplashAccessToken) {
        guard var components = URLComponents(string: String(baseURL)) else { return }
        var queryItems: [URLQueryItem] = []
        for (key, value) in query {
            var stringValue:String
            if let numberValue = value as? Int {
                stringValue = String(numberValue)
            } else {
                stringValue = (value as? String) ?? ""
            }
            queryItems.append(URLQueryItem(name: key, value: stringValue))
        }
        components.queryItems = queryItems
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(accessToken.appId!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        self.requestURL = request
        self.requestType = .get
    }
    
}

//MARK: oAuthentication Request builder

struct ImageOAuthRequestBuilder : RequestHelper {
    var requestURL: URLRequest!
    var requestBody: Any?
    var requestHeader: [String : String]?
    var baseURL: String {
        return "https://unsplash.com/oauth/authorize"
    }
    var requestType: RequestType?
    public static let publicScope = ["public"]
    public static let allScopes = [
        "public",
        "read_user",
        "write_user",
        "read_photos",
        "write_photos",
        "write_likes",
        "read_collections",
        "write_collections"
    ]
    
    private let appId : String = ""
    private let secret : String = ""
    
    init() {
    }
    
    mutating func buildAuthorizationRequest(withQuery query:[String: Any], consumerToken: String) {
        guard var components = URLComponents(string: String(baseURL)) else { return }
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: ""),
            URLQueryItem(name: "client_secret", value: ""),
            URLQueryItem(name: "scope", value: ImageOAuthRequestBuilder.allScopes.joined(separator: "+")),
        ]
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(consumerToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        self.requestURL = request
        self.requestType = .get
    }
    
}

