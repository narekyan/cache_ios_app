//
//  File.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation
import CoreData
import Combine

protocol ISearchViewModel {
    func search(_ searchTerm: String) -> CurrentValueSubject<Bool, Error>
    func memoryWarningReceived()
}

class SearchViewModel: ISearchViewModel {
    
    private var networkFeature: IImagesNetworkFeature!
    private var cacheFeature: ICacheFeature!
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkFeature: IImagesNetworkFeature, cacheFeature: ICacheFeature) {
        self.networkFeature = networkFeature
        self.cacheFeature = cacheFeature
    }
    
    func search(_ searchTerm: String) -> CurrentValueSubject<Bool, Error> {
        let fetchSubject = CurrentValueSubject<Bool, Error>(false)
        if let _ = cacheFeature.respone(for: searchTerm) {
            fetchSubject.send(true)
            return fetchSubject
        }
        networkFeature.getImages(searchTerm)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    fetchSubject.send(completion: .failure(error))
                case .finished: break
                }
            } receiveValue: { (response) in
                self.cacheFeature.keepResponse(key: searchTerm, response: response)
                fetchSubject.send(true)
            }.store(in: &subscriptions)
        return fetchSubject
    }
    
    func memoryWarningReceived() {
        cacheFeature.clear()
    }
}
