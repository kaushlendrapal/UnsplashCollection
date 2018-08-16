//
//  ImageDownloader.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit

enum ImageDownloadState {
    case new, downloaded, failed
}

enum URLTypes : String {
    case full = "full"
    case regular = "regular"
    case small  = "small"
    case thumb  = "thumb"
}

class ImageDownloader: AsynchronousOperation {
    
    let currentImage: USImage
    let cacheManager = CacheManager.shared
    var oAuthAccessToken: UnsplashAccessToken
    let imageURLType: URLTypes
    
    var networkTask: URLSessionDataTask?
    var networkCallCompletionBlock: ((Any?, Error?) -> Void)
    
    init(_ currentPhoto: USImage, imageURLType:URLTypes, accessToken: UnsplashAccessToken, requestCompletion:@escaping((Any?, Error?) -> Void)) {
        self.currentImage = currentPhoto
        networkCallCompletionBlock = requestCompletion
        self.oAuthAccessToken = accessToken
        self.imageURLType = imageURLType
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
            print("\(String(describing: self.operationName)) startNetworkCall Method Started")
            if self.isCancelled {
                self.operationCompleted()
                return
            }
            
            guard let imageThumbURL =  self.getImageURLString(for: self.imageURLType, image: self.currentImage) else {
                self.networkTask?.cancel()
                return
            }
            
            self.makeNetworkCall(requestObject: URLRequest(url: URL(string: imageThumbURL)!),
                                 requestCompletionBlock: { (jsonObject, error) in
                                    self.callNetworkCompletionBlock(response: jsonObject, error: error)
            })
            if self.networkTask?.state == .running,
                self.networkTask?.state == .suspended {
                print("\(String(describing: self.operationName)) startNetworkCall method. cancel running  operation")
                self.networkTask?.cancel()
            }
        }
    }
    
    func makeNetworkCall(requestObject: URLRequest, requestCompletionBlock:@escaping((Any?, Error?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            print("\(String(describing: self.operationName)) makeNetworkCall method")
            self.networkTask =  URLSession.shared.dataTask(with: requestObject.url!) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                strongSelf.networkTask = nil
                
                if let error = error {
                    requestCompletionBlock(nil, error)
                }
                if let responseData = data,
                    let response = response {
                    let cachedResponse = CachedURLResponse(response: response, data: responseData)
                    strongSelf.cacheManager.updateCache(cachedResponse: cachedResponse, for: requestObject.url!)
                    requestCompletionBlock(responseData, nil)
                }
            }
            self.networkTask?.resume()
        }
        
    }
    
    func callNetworkCompletionBlock(response: Any?, error: Error?) {
        if let errorObj = error {
            print(errorObj.localizedDescription)
        }  else {
            print("\(String(describing: self.operationName)) Operation completed")
            if !self.isCancelled {
                self.networkCallCompletionBlock(response, error)
            }
            operationCompleted()
        }
    }
    
    func changeOperationExecutingState(isExecuting: Bool) {
        if isExecuting {
            self.state = .executing
        } else {
            self.state = .finished
            print("\(String(describing: self.operationName)) isFinished Method")
        }
    }
    
    func operationCompleted() {
        print("\(String(describing: self.operationName)) operationCompleted method")
        changeOperationExecutingState(isExecuting: false)
    }
    
}

fileprivate extension ImageDownloader {
    func getImageURLString(for urlType:URLTypes, image:USImage) -> (String?) {
        var urlString:String?
        
        switch urlType {
        case .full:
            if let imageFullURL =  self.currentImage.urls?.thumb {
                urlString = imageFullURL
            }
        case .regular:
            if let imageRegulerURL =  self.currentImage.urls?.thumb {
                urlString = imageRegulerURL
            }
        case .small:
            if let imageSmallURL =  self.currentImage.urls?.thumb {
                urlString = imageSmallURL
            }
        case .thumb:
            if let imageThumbURL =  self.currentImage.urls?.thumb {
                urlString = imageThumbURL
            }
        }
        return urlString
    }
}




