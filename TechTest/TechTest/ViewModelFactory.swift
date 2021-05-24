//
//  ViewModelFactory.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation

final class ViewModelFactory {
    
    func getSearchViewModel(_ networkFeature: IImagesNetworkFeature, cacheFeature: ICacheFeature) -> ISearchViewModel {
        return SearchViewModel(networkFeature: networkFeature, cacheFeature: cacheFeature)
    }

    func getImagesViewModel(_ cacheFeature: ICacheFeature) -> IImagesViewModel {
        return ImagesViewModel(cacheFeature: cacheFeature)
    }
}
