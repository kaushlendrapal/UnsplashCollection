//
//  ResponseSerializer.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

/******************************************************************************
 * JSONResponseSerializer: Utility methods for handling generic response data.
 ******************************************************************************/

struct JSONResponseSerializer {
   
   static func handleJSONResponse<T: Decodable>(responseObject: Any?, httpError: Error?, ofResultType resultType: T.Type) -> JSONResult<T> {
        if let response = responseObject {
            if let resultInfo = JSONDecoder.convertResponse(response, ofType: resultType) {
                return JSONResult.success(resultInfo)
            } else if let resultInfo = JSONDecoder.convertResponse(response, ofType: TCResultData.self) {
                return JSONResult.successWithResult(resultInfo)
            } else {
                return JSONResult.failure(.parserError(nil, nil))
            }
        } else {
            return JSONResult.failure(.generalError(NSLocalizedString("Connection Error", comment: "Connection Error")))
        }
    }
}


/******************************************************************************
 * JSONDecoder: extension used to decode model of typr T provided from response data.
 ******************************************************************************/

extension JSONDecoder {
    
    static func convertResponse<T: Decodable>(_ response: Any, ofType: T.Type) -> T? {
        
        // Since data task callback is deserialising the data sometimes and we've no control over it, we need to reverse engineer to get json object to Data
        guard let data = try? JSONSerialization.data(withJSONObject: response, options: []) else { return nil }
        
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

/// Generic JSON parsing error
enum JsonToModelConversionError: Error {
    case keyNotFound
    case valueNotFound
    case typeMismatch
    case dataCorrupted
}

/// Root lavel response from service
struct TCResultData: Codable {
    var resultCode: Int
    var resultData: String
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultData = "results"
    }
}

/// JSON result type after decoder call
enum JSONResult<Value> {
    case failure(WebServiceError)
    case successWithResult(TCResultData)
    case success(Value)
    case cancelled
    
}

// generic WebServiceError for network lavel
enum WebServiceError: Error {
    case APIError(Int, String)
    case parserError(Int?, String?)
    case generalError(String)
    case networkError(Int, String)
}
