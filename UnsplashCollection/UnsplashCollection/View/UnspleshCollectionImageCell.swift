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
    let cellPadding = 20
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageWidthConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint:NSLayoutConstraint!

    var viewModel: UnspleshImageViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureView(with viewModel:UnspleshImageViewModel) -> (Void) {
        viewModel.imageViewModelInputDelegate = self
        // configure default view
        self.viewModel = viewModel
        self.imageView.image = #imageLiteral(resourceName: "Placeholder")
        self.imageLabel.text = viewModel.image.description
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        let randomValue = randomNumber(inRange: 120...220)
        imageWidthConstraint.constant = CGFloat(randomValue)
        imageHeightConstraint.constant = CGFloat(randomNumber(inRange: 100...200))
        //UI update
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.niceBlue.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = CGFloat(randomValue / 2)
        layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:0).cgPath
        
        viewModel.pendingForDownload = true
        viewModel.startDownloadingImage()
    }
    
    func downloading(image:Data?, status:ImageDownloadState) {
        
        if status == .downloaded  {
            if let imageData = image, let currentImage = UIImage(data: imageData) {
                //sucessfull download
                self.imageView.image = currentImage
                viewModel.pendingForDownload = false
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        } else if status == .failed {
            //download fail
            self.imageView.image = #imageLiteral(resourceName: "Placeholder")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            viewModel.pendingForDownload = true
            
        } else if status == .new {
            //show progress indicator
            self.imageView.image = #imageLiteral(resourceName: "Placeholder")
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            viewModel.pendingForDownload = true
        }
        
    }
}
