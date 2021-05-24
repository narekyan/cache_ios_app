//
//  NetworkFeature.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation
import Combine

protocol ICacheFeature {
    func keepResponse(key: String, response: Decodable)
    func respone(for key: String) -> Decodable?
    
    func keepImage(key: String, response: Data)
    func image(for key: String) -> Data?
    
    func clear()
}

class CacheFeature: ICacheFeature {

    private var imageCache = [String: Data]()
    private var imageUrls = [String]()
    private var maxImagesCount: Int!
    
    private var searchCache = [String: Decodable]()
    private var searchTerms = [String]()
    private var maxSearchsCount: Int!
    
    init(_ maxSearchsCount: Int = 10, _ maxImagesCount: Int = 50) {
        self.maxSearchsCount = maxSearchsCount
        self.maxImagesCount = maxImagesCount
    }
    
    func keepResponse(key: String, response: Decodable) {
        if searchTerms.count == maxSearchsCount {
            let key = searchTerms.removeFirst()
            searchCache.removeValue(forKey: key)
        }
        searchTerms.append(key)
        searchCache[key] = response
    }
    
    func respone(for key: String) -> Decodable? {
        searchCache[key]
    }
    
    func keepImage(key: String, response: Data) {
        if imageUrls.count == maxImagesCount {
            let key = imageUrls.removeFirst()
            imageCache.removeValue(forKey: key)
        }
        imageUrls.append(key)
        imageCache[key] = response
    }
    
    func image(for key: String) -> Data? {
        imageCache[key]
    }
    
    func clear() {
        imageCache.removeAll()
        imageUrls.removeAll()
        searchCache.removeAll()
        searchTerms.removeAll()
    }
}
