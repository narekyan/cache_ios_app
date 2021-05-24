//
//  ViewModelFactory.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var data: Data? {
        didSet {
            if let data = data {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
