//
//  Utility.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        guard let objects = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil),
            let loadedView = objects.first as? T else { return T() }
        
        return loadedView
    }
}


struct Device {
    static let isIPhone              =  UIDevice.current.userInterfaceIdiom == .phone
    static let screenHeight          =  Int(UIScreen.main.bounds.size.height)
    static let screenWidth           =  Int(UIScreen.main.bounds.size.width)
}

extension JSONDecoder {
    
    static func convertResponse<T: Decodable>(_ response: Any, ofType: T.Type) -> T? {
        
        // Since data task callback is deserialising the data sometimes and we've no control over it, we need to reverse engineer to get json object to Data
        guard let data = try? JSONSerialization.data(withJSONObject: response, options: []) else { return nil }
//        guard let data = response as? Data else { return nil }
        
        let jsonDecoder = JSONDecoder()
        var convertedModel: T?
        do {
            convertedModel = try jsonDecoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Json to model conversion error \(key) \(context)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Json to model conversion error \(type) \(context)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Json to model conversion error \(type) \(context)")
        } catch DecodingError.dataCorrupted(let context) {
            print("Json to model conversion error \(context)")
        } catch {
            print("There is some other error ")
        }
        
        return convertedModel
    }
}

enum JsonToModelConversionError: Error {
    case keyNotFound
    case valueNotFound
    case typeMismatch
    case dataCorrupted
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
