//
//  USImageTests.swift
//  UnsplashCollectionTests
//
//  Created by Pal,Kaushlendra on 19/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import XCTest
@testable import UnsplashCollection


class USImageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testImagerDecoderNotNil() {
        //Given
        let unspalshedImageData = Util.getResponseDataForImage()
        //When
        let jsonDecoder = JSONDecoder()
        let imageModel: USImage = try! jsonDecoder.decode(USImage.self, from: unspalshedImageData)
        //Then
        XCTAssertNotNil(imageModel)
        XCTAssertEqual(imageModel.width, Int(4560))
    }
}




