//
//  File.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation
import CoreData
import Combine

protocol IImagesViewModel {
    var numberOfElements: Int { get }
    func picture(_ index: Int, cb: @escaping (Data) -> Void)
    func fetch(_ searchTerm: String) -> CurrentValueSubject<Bool, Never>
    func memoryWarningReceived()
}

class ImagesViewModel: IImagesViewModel {

    private var response: ImagesResponse?
    private var cacheFeature: ICacheFeature!
    private var subscriptions = Set<AnyCancellable>()

    init(cacheFeature: ICacheFeature) {
        self.cacheFeature = cacheFeature
    }
    
    func fetch(_ searchTerm: String) -> CurrentValueSubject<Bool, Never> {
        let fetchSubject = CurrentValueSubject<Bool, Never>(false)
        response = cacheFeature.respone(for: searchTerm) as? ImagesResponse
        fetchSubject.send(true)
        return fetchSubject

    }
    
    var numberOfElements: Int {
        return response?.hits.count ?? 0
    }

    func picture(_ index: Int, cb: @escaping (Data) -> Void) {
        if let url = response?.hits[index].previewURL {
            if let data = cacheFeature.image(for: url) {
                cb(data)
                return
            }
            fetchImage(url) { (data) in
                self.cacheFeature.keepImage(key: url, response: data)
                cb(data)
            }
        }
    }
    
    func memoryWarningReceived() {
        cacheFeature.clear()
    }
}

extension ImagesViewModel {
    private func fetchImage(_ url: String, cb: @escaping (Data) -> Void) {
        guard let imageURL = URL(string: url) else { return  }
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let imageData: Data = try Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    cb(imageData)
                }
            } catch {
                print(error)
            }
        }
    }
}

