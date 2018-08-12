//
//  ImageDownloader.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader: AsynchronousOperation {
    
    let currentImage: USPhotoDownload
    let cacheManager = CacheManager.shared
    var oAuthAccessToken: UnsplashAccessToken
    public let accessKey: String = "8ef42698e366832076e1ab8e822fe441141239a022dda4f1d8c07c83547d6ac6"
    
    var networkTask: URLSessionDataTask?
    var networkCallCompletionBlock: ((Any?, Error?) -> Void)
    
    init(_ currentPhoto: USPhotoDownload, accessToken: UnsplashAccessToken, requestCompletion:@escaping((Any?, Error?) -> Void)) {
        self.currentImage = currentPhoto
        networkCallCompletionBlock = requestCompletion
        self.oAuthAccessToken = accessToken
        super.init()
        self.operationName = "ImageDownloader"
    }
    
    override func start() {
        if self.isCancelled {
            self.operationCompleted()
            return
        }
        self.changeOperationExecutingState(isExecuting: true)
        startNetworkCall()
    }
    
    override func main() {
        if isCancelled {
            self.operationCompleted()
            return
        }
        self.changeOperationExecutingState(isExecuting: true)
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
            var imageRequest = ImageRequestBuilder()
            imageRequest.photoURLRequest(withQuery: "", accessToken:self.oAuthAccessToken)
            
            self.makeNetworkCall(requestObject: imageRequest.requestURL,
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
            self.networkTask =  URLSession.shared.dataTask(with: requestObject.url!) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                strongSelf.networkTask = nil
                
                if let error = error {
                    requestCompletionBlock(nil, error)
                }
                if let responseData = data,
                    let response = response {
                    let cachedResponse = CachedURLResponse(response: response, data: responseData)
                    strongSelf.cacheManager.updateCache(cachedResponse: cachedResponse, for: strongSelf.currentImage.url)
                    requestCompletionBlock(responseData, nil)
                }
            }
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
    
    func operationCompleted() {
        NSLog("\(String(describing: self.operationName)) operationCompleted method")
        changeOperationExecutingState(isExecuting: false)
    }
    
}




