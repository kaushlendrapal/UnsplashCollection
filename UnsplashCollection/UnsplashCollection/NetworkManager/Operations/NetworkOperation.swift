//
//  NetworkCallOperation.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

class NetworkOperation: AsynchronousOperation {
    var requestHelper: RequestHelper
    let cacheManager = CacheManager.shared
    var requestURL:URL?
    
    var networkTask: URLSessionDataTask?
    var networkCallCompletionBlock: ((Any?, Error?) -> Void)
    fileprivate var session:URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init(_ requestHealper: RequestHelper, requestCompletion:@escaping((Any?, Error?) -> Void)) {
        self.requestHelper = requestHealper
        self.networkCallCompletionBlock = requestCompletion
        super.init()
        self.operationName = "NetworkOperation"
    }
    
    convenience init(_ requestHealper: RequestHelper,urlSession: URLSession, requestCompletion:@escaping((Any?, Error?) -> Void)) {
        self.init(requestHealper, requestCompletion: requestCompletion)
        self.session = urlSession
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
            //used for cache key
            self.requestURL = self.requestHelper.requestURL.url!
            self.makeNetworkCall(requestObject: self.requestHelper.requestURL,
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
            self.networkTask =  self.session.dataTask(with: requestObject) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                strongSelf.networkTask = nil
                if let error = error {
                    requestCompletionBlock(nil, error)
                    return
                }
                if let responseData = data, let httpResponse = response as? HTTPURLResponse {
                    strongSelf.onSucessResponse(responseData: responseData, httpResponse: httpResponse, requestCompletionBlock: requestCompletionBlock)
                } else {
                    print("not a valid http response")
                    requestCompletionBlock(nil, WebServiceError.APIError(400, "Bad request"))
                }
            }
            self.networkTask?.resume()
        }
    }
    
    func onSucessResponse(responseData: Data, httpResponse: HTTPURLResponse, requestCompletionBlock:@escaping((Any?, Error?) -> Void)) -> Void {
        
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
            if let requesturl = self.requestURL {
                self.cacheManager.updateCache(cachedResponse: cachedResponse, for: requesturl)
            }
            requestCompletionBlock(resultJSONData, nil)
            
        default:
            guard (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]) != nil else {
                print("error trying to convert data to JSON")
                requestCompletionBlock(nil, WebServiceError.parserError(200, "response json invalid"))
                return
            }
            print("GET resquest not successful. http status code \(httpResponse.statusCode)")
            requestCompletionBlock(nil, WebServiceError.APIError(httpResponse.statusCode, "Somthing wrong happened, please try after some time"))
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
        if isExecuting {
            self.state = .executing
        } else {
            self.state = .finished
            print("\(String(describing: self.operationName)) isFinished Method")
        }
    }
    
}
