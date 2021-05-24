//
//  TechTestTests.swift
//  TechTestTests
//
//  Created by Narek on 30.04.21.
//

import XCTest
@testable import TechTest

class TechTestTests: XCTestCase {
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCacheImages() throws {
        let cacheFeature: ICacheFeature = CacheFeature(1, 1)
        let key1 = "test1"
        let key2 = "test2"
        
        cacheFeature.keepImage(key: key1, response: Data())
        XCTAssert(cacheFeature.image(for: key1) != nil)
        
        cacheFeature.keepImage(key: key2, response: Data())
        XCTAssert(cacheFeature.image(for: key1) == nil)
        
        cacheFeature.clear()
        XCTAssert(cacheFeature.image(for: key2) == nil)
    }
    
    func testCacheResponses() throws {
        let cacheFeature: ICacheFeature = CacheFeature(1, 1)
        let key1 = "test1"
        let key2 = "test2"
        
        cacheFeature.keepResponse(key: key1, response: ImagesResponse(hits: []))
        XCTAssert(cacheFeature.respone(for: key1) != nil)
        
        cacheFeature.keepResponse(key: key2, response: ImagesResponse(hits: [Image(previewURL: "some_url")]))
        XCTAssert(cacheFeature.respone(for: key1) == nil)
        
        let image = (cacheFeature.respone(for: key2) as? ImagesResponse)?.hits.first
        XCTAssert(image?.previewURL == "some_url")
        
        cacheFeature.clear()
        XCTAssert(cacheFeature.image(for: key2) == nil)
    }

}
