//
//  ViewController.swift
//  TechTest
//
//  Created by Narek on 30.04.21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    weak var coordinatorDelegate: IStartCoordinator?
    var imagesNetworkFeature: IImagesNetworkFeature?
    var cacheFeature: ICacheFeature?    
    
    lazy var viewModel: ISearchViewModel = {
        guard let f1 = imagesNetworkFeature, let f2 = cacheFeature else { fatalError() }
        return ViewModelFactory().getSearchViewModel(f1, cacheFeature: f2)
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    @IBAction func search() {
        if let searchTerm = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchTerm.count > 0 {
            activityIndicator.startAnimating()
            viewModel.search(searchTerm).sink { (completion) in
                switch completion {
                case .failure(let error): do {
                    let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                default: break
                }
            } receiveValue: { (result) in
                self.activityIndicator.stopAnimating()
                if result {
                    self.coordinatorDelegate?.showList(searchTerm)
                }
            }.store(in: &subscriptions)
        }
    }
    
    override func didReceiveMemoryWarning() {
        viewModel.memoryWarningReceived()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
