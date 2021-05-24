//
//  ViewController.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import UIKit
import Combine

class ImagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var coordinatorDelegate: IStartCoordinator?
    var searchTerm = ""
    var cacheFeature: ICacheFeature?
    
    lazy var viewModel: IImagesViewModel = {
        guard let f1 = cacheFeature else { fatalError() }
        return ViewModelFactory().getImagesViewModel(f1)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.fetch(searchTerm).sink { (_) in
            self.collectionView.reloadData()
        }.store(in: &subscriptions)
    }
    
    override func didReceiveMemoryWarning() {
        viewModel.memoryWarningReceived()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfElements
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        viewModel.picture(indexPath.row) { (data) in cell.data = data }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/3-5, height: collectionView.frame.width/3-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
