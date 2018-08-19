//
//  MockNetworkQueueManager.swift
//  UnsplashCollectionTests
//
//  Created by Pal,Kaushlendra on 19/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit
import XCTest
@testable import UnsplashCollection

class MockNetworkQueueManager: NetworkQueueManager {
    
    weak var expectation:XCTestExpectation?
    var mockResponse: MockUrlResponse
    
    init(mockResponse:MockUrlResponse) {
        self.mockResponse = mockResponse
        super.init()
    }

    override func makeNetworkCall(requestHelper: RequestHelper, authRequired: Bool, requestCompletion: @escaping ((Any?, Error?) -> Void)) -> NetworkOperation? {
        //Setup
        let requestHelper = Util.buildRequestHelperForImageSearch()
        let session = URLSessionMock(mockResponse:mockResponse)
        let mockCompletionBlock: MockCompletionBlock = { (jsonObject, error) in
            if let responseError = self.mockResponse.responseError {
                requestCompletion(nil, responseError)
            } else {
                requestCompletion(jsonObject, nil)
            }
            self.expectation?.fulfill()
        }
        
        let networkOperation = NetworkOperation(requestHelper,urlSession:session, requestCompletion: mockCompletionBlock)
        networkOperation.makeNetworkCall(requestObject: requestHelper.requestURL, requestCompletionBlock: mockCompletionBlock)
        
        return networkOperation
    }
    

}
