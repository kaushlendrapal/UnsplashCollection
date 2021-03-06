//
//  UnspleshCollectionImageCell.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

/******************************************************************************
 * UnspleshCollectionImageCell: collection view reusable cell
 ******************************************************************************/

class UnspleshCollectionImageCell: UICollectionViewCell, UnspleshImageVMInputDelegate {
    
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
        imageWidthConstraint.constant = CGFloat(Device.screenWidth / 2)
        imageHeightConstraint.constant = CGFloat(320)
        //UI update
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.niceBlue.cgColor
        self.contentView.layer.masksToBounds = true
        
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
