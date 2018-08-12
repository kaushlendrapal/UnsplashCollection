//
//  NetworkCallOperation.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

class NetworkOperation: AsynchronousOperation {
    var requestParams: [String: Any]
    var oAuthAccessToken: UnsplashAccessToken
    let cacheManager = CacheManager.shared
    var requestURL:URL?
    
    var networkTask: URLSessionDataTask?
    var networkCallCompletionBlock: ((Any?, Error?) -> Void)
    
    
    init(_ requestParams: [String: Any] , accessToken: UnsplashAccessToken, requestCompletion:@escaping((Any?, Error?) -> Void)) {
        self.requestParams = requestParams
        self.oAuthAccessToken = accessToken
        self.networkCallCompletionBlock = requestCompletion
        super.init()
        self.operationName = "NetworkOperation"
    }
    
    override func start() {
        if self.isCancelled {
            self.operationCompleted()
            return
        } else {
            self.changeOperationExecutingState(isExecuting: true)
        }
        
        
        startNetworkCall()
    }
    
    override func main() {
        if self.isCancelled {
            self.operationCompleted()
            return
        } else {
            self.changeOperationExecutingState(isExecuting: true)
        }
        
        startNetworkCall()
    }
    
    func startNetworkCall() {
        
        if self.isCancelled {
            self.operationCompleted()
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            NSLog("\(String(describing: self.operationName)) startNetworkCall Method Started")
            if self.isCancelled {
                self.operationCompleted()
                return
            }
            var imageSearchRequest = ImageSearchRequestBuilder()
            imageSearchRequest.photoListRequest(withQuery: self.requestParams, accessToken:self.oAuthAccessToken)
            //used for cache key
            self.requestURL = imageSearchRequest.requestURL.url!
            self.makeNetworkCall(requestObject: imageSearchRequest.requestURL,
                                 requestCompletionBlock: { (jsonObject, error) in
                                    self.callNetworkCompletionBlock(response: jsonObject, error: error)
            })
            if self.networkTask?.state == .running,
                self.networkTask?.state == .suspended {
                NSLog("\(String(describing: self.operationName)) startNetworkCall method. cancel running  operation")
                self.networkTask?.cancel()
            }
        }
        
    }
    
    func makeNetworkCall(requestObject: URLRequest, requestCompletionBlock:@escaping((Any?, Error?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            NSLog("\(String(describing: self.operationName)) makeNetworkCall method")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            self.networkTask =  session.dataTask(with: requestObject) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                strongSelf.networkTask = nil
                
                if let error = error {
                    requestCompletionBlock(nil, error)
                }
                
                if let responseData = data,
                    let httpResponse = response as? HTTPURLResponse
                {
                    print("httpResponse status code \(httpResponse.statusCode)")
                    switch(httpResponse.statusCode)
                    {
                    case 200:
                        guard let JSONObject = try? JSONSerialization.jsonObject(with: responseData, options: [.allowFragments]) as? [String: AnyObject],
                        let resultJSONData = JSONObject?["results"] as? [AnyObject]
                        else {
                            print("error trying to convert data to JSON")
                            requestCompletionBlock(nil, WebServiceError.parserError(200, "response json invalid"))
                            return
                        }
                        let cachedResponse = CachedURLResponse(response: httpResponse, data: responseData)
                        strongSelf.cacheManager.updateCache(cachedResponse: cachedResponse, for: strongSelf.requestURL!)
                        requestCompletionBlock(resultJSONData, nil)
                        
                    default:
                        guard let JSONObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                            print("error trying to convert data to JSON")
                            requestCompletionBlock(nil, WebServiceError.parserError(200, "response json invalid"))
                            return
                        }
                        print("GET resquest not successful. http status code \(httpResponse.statusCode)")
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
    
    func callNetworkCompletionBlock(response: Any?, error: Error?) {
        if let errorObj = error {
            print(errorObj.localizedDescription)
        }  else {
            NSLog("\(String(describing: self.operationName)) Operation completed")
            if !self.isCancelled {
                self.networkCallCompletionBlock(response, error)
            }
            operationCompleted()
        }
        
    }
    
    func operationCompleted() {
        NSLog("\(String(describing: self.operationName)) operationCompleted method")
        changeOperationExecutingState(isExecuting: false)
    }
    
    func changeOperationExecutingState(isExecuting: Bool) {
        NSLog("\(String(describing: self.operationName)) changeOperationExecutingState method")
        if isExecuting {
            self.state = .executing
            NSLog("\(String(describing: self.operationName)) isExecuting Method")
        } else {
            self.state = .finished
            NSLog("\(String(describing: self.operationName)) isFinished Method")
        }
    }
    
}
