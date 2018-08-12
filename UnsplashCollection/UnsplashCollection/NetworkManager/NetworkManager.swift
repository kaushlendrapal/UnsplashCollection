//
//  NetworkManager.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 12/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager  {
    
    static let sharedManager = NetworkManager()
    var networkTask: URLSessionDataTask?
    /// unsplashToken got updated to not nil after oAuth setup callback sucess
    var unsplashToken:UnsplashAccessToken?
    
    //MARK: Refresh token API
    func makeNetworkCall(requestObject: URLRequest, requestCompletionBlock:@escaping((Any?, Error?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            self.networkTask =  session.dataTask(with: requestObject) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                strongSelf.networkTask = nil
                if let error = error {
                    requestCompletionBlock(nil, error)
                }
                
                if let responseData = data,
                    let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse status code \(httpResponse.statusCode)")
                    switch(httpResponse.statusCode) {
                    case 200:
                        guard let JSONObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                            print("error trying to convert data to JSON")
                            requestCompletionBlock(nil, WebServiceError.parserError(200, "response json invalid"))
                            return
                        }
                        requestCompletionBlock(JSONObject, nil)
                        
                    default:
                        guard let JSONObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]  else {
                            print("error trying to convert data to JSON")
                            requestCompletionBlock(nil, WebServiceError.parserError(200, "response json invalid"))
                            return
                        }
                        print("POST resquest not successful. http status code \(httpResponse.statusCode)")
                        requestCompletionBlock(nil, WebServiceError.APIError(httpResponse.statusCode, "Somthing wrong happened, please try after some time"))
                    }
                } else {
                    print("not a valid http response")
                    requestCompletionBlock(nil, WebServiceError.APIError(400, "Bad request"))
                }
            }
            self.networkTask?.resume()
        }
    }
    
    //MARK: Unsplash oAuth setup
    
    public func setUpWithAppId(appId : String, secret : String, scopes: [String] = UnsplashAuthManager.allScopes) {
        
        UnsplashAuthManager.sharedAuthManager = UnsplashAuthManager(appId: appId, secret: secret, scopes: scopes)
        if let token = UnsplashAuthManager.sharedAuthManager.getAccessToken() {
            self.unsplashToken = token
        }
    }
    
    public func authorizeFromController(controller: UIViewController, completion:@escaping (Bool, Error?) -> Void) {
        precondition(UnsplashAuthManager.sharedAuthManager != nil, "call `UnsplashAuthManager.init` before calling this method")

        UnsplashAuthManager.sharedAuthManager.authorizeFromController(controller: controller, completion: { token, error in
            if let accessToken = token {
                self.unsplashToken = accessToken
                print("######   \(accessToken.accessToken)          ####")
                completion(true, nil)
            } else  {
                completion(false, error!)
            }
        })
    }
}
