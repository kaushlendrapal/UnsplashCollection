//
//  NetworkQueueManager.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

/******************************************************************************
 * NetworkQueueManager: queue to manage all the async opearion. This will
 * take care of cancel , resume the operation on conditional bases.
 ******************************************************************************/
class NetworkQueueManager: NSObject {
    
    static let shared = NetworkQueueManager()
    var networkQueue: OperationQueue = OperationQueue()
    var accessToken:UnsplashAccessToken? {
        return NetworkManager.sharedManager.unsplashToken
    }
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
    
    override init() {
        self.networkQueue.maxConcurrentOperationCount = 5
    }
    
    @discardableResult
    func makeNetworkCall (requestHelper: RequestHelper, authRequired:Bool, requestCompletion:@escaping((Any?, Error?) -> Void)) -> NetworkOperation? {
        
        self.checkAndRemoveCancelledOperations()
        if (self.accessToken == nil) && authRequired == true  {
            self.cancelAllNetworkOperation()
            return nil
        }
        
        let networkOperation = NetworkOperation(requestHelper, requestCompletion: { (response, error) in
            requestCompletion(response, error)
        })
        networkOperation.name = String("NetworkOperation")
        networkQueue.addOperation(networkOperation)
        
        return networkOperation
    }
    
    
    func cancelAllNetworkOperation() {
        NSLog("cancelAllNetworkOperation method")
        networkQueue.cancelAllOperations()
        for operation in networkQueue.operations {
            let networkOperation = operation as? AsynchronousOperation
            if let networkOp = networkOperation,
                networkOp.isExecuting {
                networkOp.cancel()
            }
        }
    }
    
    func checkAndRemoveCancelledOperations() {
        NSLog("checkAndRemoveCancelledOperations method")
        for operation in networkQueue.operations {
            let networkOperation = operation as? AsynchronousOperation
            if let networkOp = networkOperation,
                networkOp.isCancelled {
                networkOp.cancel()
            }
        }
    }
}


extension NetworkQueueManager {
    
    @discardableResult
    func downloadImage( with requestHelper: RequestHelper, authRequired:Bool, requestCompletion:@escaping((Any?, Error?) -> Void)) -> ImageDownloader? {
        
        if (self.accessToken == nil) && authRequired == true  {
            self.cancelAllNetworkOperation()
            return nil
        }
        
        let imageDownloadOperation = ImageDownloader(requestHelper, imageURLType: .thumb) { (imageData, error) in
            requestCompletion(imageData, error)
        }
        imageDownloadOperation.name = String("ImageDownloader")
        downloadQueue.addOperation(imageDownloadOperation)
        
        return imageDownloadOperation
    }
        
}





