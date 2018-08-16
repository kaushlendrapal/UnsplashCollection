//
//  Utility.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit

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
}

public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
    let length = Int64(range.upperBound - range.lowerBound + 1)
    let value = Int64(arc4random()) % length + Int64(range.lowerBound)
    return T(value)
}

