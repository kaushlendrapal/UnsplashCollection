//
//  MockURLSession.swift
//  UnsplashCollectionTests
//
//  Created by Pal,Kaushlendra on 17/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import XCTest

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeWasCalled = false
    
    override func resume() {
        resumeWasCalled = true
    }
}

class MockUrlResponse: HTTPURLResponse {
//    var completionBlock: MockCompletionBlock?
    var responseError: Error?
    var expectation: XCTestExpectation?
    
}

class URLSessionMock: URLSession {
    
    var responseDataTask = MockURLSessionDataTask()
    private var mockResponse: MockUrlResponse?
    
    init(mockResponse: MockUrlResponse) {
        self.mockResponse = mockResponse
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return responseDataTask
    }
    
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        
        let responseData = Util.getResponseDataForImages()
        responseDataTask.resume()
        if let mockResponse = mockResponse {
            if let responseError = mockResponse.responseError {
                completionHandler(nil,nil, responseError)
            } else {
                completionHandler(responseData,mockResponse, nil)
            }
        }
        return responseDataTask
    }
    
}

