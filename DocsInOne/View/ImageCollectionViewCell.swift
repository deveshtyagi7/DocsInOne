//
//  ImageCollectionViewCell.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 22/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
     var image : UIImage?{
            didSet{
                updateImageCollection()
            }
        }
        
        func updateImageCollection(){
            if let image = image{
                imageView.image = image
            }
        }
}
