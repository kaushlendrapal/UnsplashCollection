//
//  UnspleshCollectionImageCell.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

protocol UnspleshImageCellOutputDelegate: class { }

class UnspleshCollectionImageCell: UICollectionViewCell, UnspleshImageVMInputDelegate {
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureView(with viewModel:UnspleshImageViewModel) -> (Void) {
        viewModel.imageViewModelInputDelegate = self
        // configure default view
        self.imageView.image = #imageLiteral(resourceName: "Placeholder")
        self.imageLabel.text = viewModel.image.description
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    func imageDownloadedSucessfully(with image:USImage?, status:ImageDownloadState) {
        
        if status == .downloaded {
            if let currentImage = image {
                //sucessfull download
                self.imageView.image = currentImage.image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            }
        } else if status == .failed {
            //download fail
            self.imageView.image = #imageLiteral(resourceName: "Placeholder")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
        } else if status == .new {
            //show progress indicator
            self.imageView.image = #imageLiteral(resourceName: "Placeholder")
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
        
    }
    
    
}
