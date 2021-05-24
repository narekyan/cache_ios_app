//
//  CoordinatorManager.swift
//  fanFone
//
//  Created by Narek on 10/22/20.
//  Copyright © 2020 fanFone. All rights reserved.
//

import UIKit

protocol IStartCoordinator: class {
    func showList(_ searchTerm: String)
}

class StartCoordinator {
 
    private var navigationController: UINavigationController?
    
    private let cacheFeature: ICacheFeature = CacheFeature()
    
    func start(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
        startSearch()
    }       
}

extension StartCoordinator {
    private func startSearch() {
        let vc = pushViewController(SearchViewController.self)
        vc.coordinatorDelegate = self
        vc.imagesNetworkFeature = ImagesNetworkFeature()
        vc.cacheFeature = cacheFeature
    }
    
    private func startList(_ searchTerm: String) {
        let vc = pushViewController(ImagesViewController.self)
        vc.searchTerm = searchTerm
        vc.cacheFeature = cacheFeature
    }
    
    private func pushViewController<T: UIViewController>(_ type: T.Type) -> T {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: type))

        self.navigationController?.pushViewController(vc, animated: true)
        return vc as! T
    }
}

extension StartCoordinator: IStartCoordinator {
    func showList(_ searchTerm: String) {
        startList(searchTerm)
    }
}
