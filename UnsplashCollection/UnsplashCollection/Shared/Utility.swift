//
//  Utility.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit
import os.log

let Logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Unsplashed")

struct Device {
    static let isIPhone              =  UIDevice.current.userInterfaceIdiom == .phone
    static let screenHeight          =  Int(UIScreen.main.bounds.size.height)
    static let screenWidth           =  Int(UIScreen.main.bounds.size.width)
}

extension URL {
    var queryPairs : [String : String] {
        var results = [String: String]()
        let pairs  = self.query?.components(separatedBy: CharacterSet(charactersIn: "&")) ?? []
        for pair in pairs {
            let kv = pair.components(separatedBy: CharacterSet(charactersIn: "="))
            results.updateValue(kv[1], forKey: kv[0])
        }
        return results
    }
    
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

extension UIColor {
    @nonobjc class var niceBlue: UIColor {
        return UIColor(red: 18.0 / 255.0, green: 114.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var leaf: UIColor {
        return UIColor(red: 126.0 / 255.0, green: 179.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
    }
}

// MARK: - Int extension

extension Int {
    var megabytes: Int { return self * 1024 * 1024 }
}


public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
    let length = Int64(range.upperBound - range.lowerBound + 1)
    let value = Int64(arc4random()) % length + Int64(range.lowerBound)
    return T(value)
}
