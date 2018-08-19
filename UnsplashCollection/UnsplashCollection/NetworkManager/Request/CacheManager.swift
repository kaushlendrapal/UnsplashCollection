//
//  CacheManager.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    
    private static var cache = URLCache(memoryCapacity: 50.megabytes, diskCapacity: 100.megabytes, diskPath: "sigmaITC")

    func updateCache( cachedResponse: CachedURLResponse, for url: URL) {
        CacheManager.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }
    
    func getCachedResponse(for url:URL) -> (CachedURLResponse?) {
       return CacheManager.cache.cachedResponse(for: URLRequest(url: url))
    }
    
}
