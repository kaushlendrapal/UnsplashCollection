//
//  UnsplashCollectionViewViewModelTests.swift
//  UnsplashCollectionTests
//
//  Created by Pal,Kaushlendra on 19/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import XCTest
@testable import UnsplashCollection

class UnsplashCollectionViewViewModelTests: XCTestCase, UnspleshCollectionVMInputDelegate {
    
    var unsplashCollectionViewVM: UnsplashCollectionViewViewModel!
    
    override func setUp() {
        super.setUp()
        unsplashCollectionViewVM = UnsplashCollectionViewViewModel()
        unsplashCollectionViewVM.collectionVMDelegate = self
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfSection() {
        //When
        let returnValue = unsplashCollectionViewVM.numberOfSection()
        //Then
        XCTAssertEqual(returnValue, Int(2))
    }
    
    func testNumberOfItemsInSection_withNoDataSource() {
        //Given
        let section = 0
        unsplashCollectionViewVM.collectionDataSource = nil
        //When
        let resultValue = unsplashCollectionViewVM.numberOfItemsInSection(section: section)
        //Then
        XCTAssertEqual(resultValue, 0)
    }
    
    func testNumberOfItemsInSection_withDataSource() {
        //Given
        let section = 0
        unsplashCollectionViewVM.collectionDataSource = Util.getdumyDataforImageList()
        //When
        let resultValue = unsplashCollectionViewVM.numberOfItemsInSection(section: section)
        //Then
        XCTAssertEqual(resultValue, 3)
    }
    
    func testGetImageModel_forIndexPathOutOfBound() {
        //Given
        let indexPath = IndexPath(row: 3, section: 0)
        //When
        let resultData = unsplashCollectionViewVM.getImageModel(at: indexPath)
        //Then
        XCTAssertNil(resultData)
    }
    
    func testGetImageModel_forIndexPath() {
        //Given
        let indexPath = IndexPath(row: 1, section: 0)
        unsplashCollectionViewVM.collectionDataSource = Util.getdumyDataforImageList()
        //When
        let resultData = unsplashCollectionViewVM.getImageModel(at: indexPath)
        //Then
        XCTAssertNotNil(resultData)
    }
    
    func testFetchAllImages_sucessfully() {
        //Given
        let mockResponse = MockUrlResponse(url:URL(string: "https://api.unsplash.com/search/photos")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let networkQManager = MockNetworkQueueManager(mockResponse: mockResponse)
        networkQManager.expectation = self.expectation(description: "async call waiting")
        let unsplashCollectionVM = UnsplashCollectionViewViewModel(networkQueueManager: networkQManager)
        unsplashCollectionVM.collectionVMDelegate = self
        let searchCriteria = SearchCriteria(perPage: 100, orderBy: "popular", orientation: "squarish", searchText: "Nature")
        //When
        unsplashCollectionVM.fetchAllImages(searchCriteria: searchCriteria)
        waitForExpectations(timeout: 5.0) { (error) in
            print("######  full filled expectation  ########")
            XCTAssertNotNil(unsplashCollectionVM.collectionDataSource)
        }
    }
    
    func testFetchAllImages_failed() {
        //Given
        let mockResponse = MockUrlResponse(url:URL(string: "https://api.unsplash.com/search/photos")!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
        mockResponse.responseError = WebServiceError.APIError(404, "Bad request")
        
        let networkQManager = MockNetworkQueueManager(mockResponse: mockResponse)
        networkQManager.expectation = self.expectation(description: "async call waiting")
        let unsplashCollectionVM = UnsplashCollectionViewViewModel(networkQueueManager: networkQManager)
        unsplashCollectionVM.collectionVMDelegate = self
        let searchCriteria = SearchCriteria(perPage: 100, orderBy: "popular", orientation: "squarish", searchText: "Nature")
        //When
        unsplashCollectionVM.fetchAllImages(searchCriteria: searchCriteria)
        waitForExpectations(timeout: 5.0) { (error) in
            print("######  full filled expectation  ########")
            XCTAssertNil(unsplashCollectionVM.collectionDataSource)
        }
    }
    
    //MARK:- UnspleshCollectionVMInputDelegate
    
    func handleGeneraErrorResponse(genericError: WebServiceError) {
        //Given
        
    }
    
    func handleCollectionViewReloadOnDataSourceUpdate() {
        
    }
    
}
