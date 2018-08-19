//
//  NetworkOperationTests.swift
//  UnsplashCollectionTests
//
//  Created by Pal,Kaushlendra on 17/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import XCTest
@testable import UnsplashCollection

typealias MockCompletionBlock = ((Any?, Error?) -> Void)

class NetworkOperationTests: XCTestCase {
    
    var networkOperation: NetworkOperation?
    var searchCriteria = SearchCriteria(perPage: 100, orderBy: "popular", orientation: "squarish", searchText: "Nature")

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        networkOperation = nil
        super.tearDown()
    }
    
    func testMakeNetworkCall_withSucessResponse() {
        //Setup
        let requestHelper = Util.buildRequestHelperForImageSearch()
        let mockResponse = MockUrlResponse(url:URL(string: "https://api.unsplash.com/search/photos")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let session = URLSessionMock(mockResponse:mockResponse)
        networkOperation = NetworkOperation(requestHelper,urlSession:session, requestCompletion: {_,_ in })
        //Given
        weak var delayedExpectation = self.expectation(description:"async call waiting");
        //Then
        let mockCompletionBlock: MockCompletionBlock = { (jsonObject, error) in
            let jsonResult = JSONResponseSerializer.handleJSONResponse(responseObject: jsonObject, httpError: error, ofResultType: [USImage].self)
            if case let JSONResult.success(images) = jsonResult {
                XCTAssertNotNil(images)
                XCTAssertTrue(images.count > 0)
            }
            delayedExpectation?.fulfill()
        }

        //When
        networkOperation?.makeNetworkCall(requestObject: requestHelper.requestURL, requestCompletionBlock: mockCompletionBlock)
        //Waiting
        waitForExpectations(timeout: 5.0) { (error) in
            print("######  full filled expectation  ########")
            }

    }
    
    func testMakeNetworkCall_withFailureResponse() {
        //Setup
        let requestHelper = Util.buildRequestHelperForImageSearch()
        let mockResponse = MockUrlResponse(url:URL(string: "https://api.unsplash.com/search/photos")!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
        mockResponse.responseError = WebServiceError.APIError(404, "Bad request")
        let session = URLSessionMock(mockResponse:mockResponse)
        networkOperation = NetworkOperation(requestHelper,urlSession:session, requestCompletion: {_,_ in })
        //Given
        weak var delayedExpectation = self.expectation(description:"async call waiting");
        //Then
        let mockCompletionBlock: MockCompletionBlock = { (jsonObject, error) in
            XCTAssertNotNil(error)
            guard case let WebServiceError.APIError(code, desc) = error! else { return }
            XCTAssertEqual(code, 404)
            XCTAssertEqual(desc, "Bad request")
            delayedExpectation?.fulfill()
        }
        
        //When
        networkOperation?.makeNetworkCall(requestObject: requestHelper.requestURL, requestCompletionBlock: mockCompletionBlock)
        //Waiting
        waitForExpectations(timeout: 5.0) { (error) in
            print("######  full filled expectation  ########")
        }
    }
    
}
