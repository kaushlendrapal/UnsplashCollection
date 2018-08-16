//
//  NetworkQueueManager.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

class NetworkQueueManager: NSObject {
    
    static let shared = NetworkQueueManager()
    var networkQueue: OperationQueue = OperationQueue()
    var accessToken:UnsplashAccessToken? {
        return NetworkManager.sharedManager.unsplashToken
    }
    
    override init() {
        self.networkQueue.maxConcurrentOperationCount = 5
    }
    
    @discardableResult
    func makeNetworkCall (requestHelper: RequestHelper, requestCompletion:@escaping((Any?, Error?) -> Void)) -> NetworkOperation? {
        
        self.checkAndRemoveCancelledOperations()
        guard let unspleadToken = self.accessToken else {
            self.cancelAllNetworkOperation()
            return nil
        }
        
        let networkOperation = NetworkOperation(requestHelper, accessToken: unspleadToken, requestCompletion: { (response, error) in
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







