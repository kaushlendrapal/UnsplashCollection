//
//  ResponseSerializer.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

struct JSONResponseSerializer {
    
    func handleResponse(result: Any?) -> Result? {
        
        if let apiError = result as? NSError {
            if apiError.code == NSURLErrorNotConnectedToInternet || apiError.code == NSURLErrorTimedOut {
                return Result.failure(.networkError(apiError.code, apiError.localizedDescription))
            } else {
                return Result.failure(.APIError(apiError.code, apiError.localizedDescription))
            }
        }
        return nil
    }
    
    func handleJSONResponse<T: Decodable>(responseObject: Any?, httpError: Error?, ofResultType resultType: T.Type) -> JSONResult<T> {
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
    
    func getTCErrorResponse<T: Decodable>(error: Error) -> JSONResult<T>? {
        return JSONResult.failure(.generalError(error.localizedDescription))
    }
}

struct TCResultData: Codable {
    var resultCode: Int
    var resultData: String
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultData = "results"
    }
}

enum Result {
    case successWith(Int, String?)
    case failure(WebServiceError)
}

enum JSONResult<Value> {
    case failure(WebServiceError)
    case successWithResult(TCResultData)
    case success(Value)
    case cancelled
    
}

enum WebServiceError: Error {
    case APIError(Int, String)
    case parserError(Int?, String?)
    case generalError(String)
    case networkError(Int, String)
}
