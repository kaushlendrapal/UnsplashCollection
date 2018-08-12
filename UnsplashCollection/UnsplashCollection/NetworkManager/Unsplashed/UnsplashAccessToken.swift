//
//  UnsplashAccessToken.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 12/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation


public struct UnsplashAccessToken : Codable {
    
    var appId: String?
    let accessToken: String?
    let refreshToken: String?
    let tokenType:String?
    
    enum CodingKeys: String, CodingKey {
        
        case appId = "appId"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType   = "token_type"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.appId = try values.decodeIfPresent(String.self, forKey: .appId)
        self.accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        self.refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        self.tokenType = "bearer"
        self.appId = "8ef42698e366832076e1ab8e822fe441141239a022dda4f1d8c07c83547d6ac6"
    }
    
}
