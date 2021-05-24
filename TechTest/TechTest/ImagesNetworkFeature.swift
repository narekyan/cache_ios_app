//
//  NetworkFeature.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation
import Combine


fileprivate let ApiUrl = "https://pixabay.com/api?"

protocol IImagesNetworkFeature {
    func getImages(_ q: String) -> PassthroughSubject<ImagesResponse?, Error>
}

class ImagesNetworkFeature: NetworkFeature, IImagesNetworkFeature {
    
    private let key = "13197033-03eec42c293d2323112b4cca6"
    
    func getImages(_ q: String) -> PassthroughSubject<ImagesResponse?, Error> {
        
        let params = ["image_type":"photo",
                      "key":key,
                      "q":q]
        let url = ApiUrl+constructQuery(params: params)
        
        return get(url)
    }
}
