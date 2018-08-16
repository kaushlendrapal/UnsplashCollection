//
//  RequestBuilder.swift
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
    var requestHeader: [String: String] { get }
    var requestType: RequestType { get }
    var accessToken: UnsplashAccessToken? { get }
    
}

//MARK: image Search request

struct ImageSearchRequestBuilder: RequestHelper {
    var requestURL: URLRequest!
    var requestType: RequestType
    var accessToken: UnsplashAccessToken?
    var requestBody: Any?
    var requestHeader: [String : String] = ["Accept": "application/json", "Content-Type": "application/json"]
    var baseURL: String {
        return "https://api.unsplash.com/search/photos"
    }
    
    init(accessToken: UnsplashAccessToken?, requestType:RequestType = .get) {
        self.requestType = requestType
        var request = URLRequest(url: URL(string: baseURL)!)
        if let appId = accessToken?.appId {
            request.addValue("Client-ID \(appId)", forHTTPHeaderField: "Authorization")
        }
        for (key, headerValue) in requestHeader {
            request.addValue(headerValue, forHTTPHeaderField: key)
        }
        request.httpMethod = requestType.rawValue
        request.cachePolicy = .useProtocolCachePolicy
        self.requestURL = request
    }
    
    
    mutating func photoListRequest(withQuery query:[String: Any]) {
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
        self.requestURL.url = url
    }
    
}


//MARK: oAuthentication Request builder

struct OAuthRequestBuilder: RequestHelper {
    var requestType: RequestType
    var accessToken: UnsplashAccessToken?
    
    var requestURL: URLRequest!
    var requestBody: Any?
    var requestHeader: [String : String] = ["Accept": "application/json", "Content-Type": "application/json"]
    var baseURL: String {
        return "https://unsplash.com/oauth/token"
    }
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
    
    init(accessToken: UnsplashAccessToken? = nil, requestType:RequestType = .post) {
        self.requestType = requestType
        var request = URLRequest(url: URL(string: baseURL)!)
        if let appId = accessToken?.appId {
            request.addValue("Client-ID \(appId)", forHTTPHeaderField: "Authorization")
        }
        for (key, headerValue) in requestHeader {
            request.addValue(headerValue, forHTTPHeaderField: key)
        }
        request.httpMethod = requestType.rawValue
        request.cachePolicy = .useProtocolCachePolicy
        self.requestURL = request
    }
    
    mutating func buildAuthorizationRequest(withQuery requestParams:[String: String]) {
        if self.requestType == .post {
            self.requestURL.httpBody = try? JSONSerialization.data(withJSONObject: requestParams, options: [])
        }
//        self.requestURL.addValue("Client-ID \(consumerToken)", forHTTPHeaderField: "Authorization")
    }
    
}

