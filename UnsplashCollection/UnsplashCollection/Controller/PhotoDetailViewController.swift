//
//  PhotoDetailViewController.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 14/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

class PhotoDetailViewController: BaseViewController, PhotoDetailVMInputDelegate {
    
    var viewModel:PhotoDetailViewModel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoInfo: UILabel!
    
    class func photoDetailViewControllerOnLaunch(with viewModel:Any) -> (PhotoDetailViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let identifier = "PhotoDetailViewController"
        let photoDetailVC: PhotoDetailViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! PhotoDetailViewController
        guard let homeViewModel = viewModel as? PhotoDetailViewModel else {
            return photoDetailVC
        }
        
        photoDetailVC.viewModel = homeViewModel
        photoDetailVC.viewModel.photoDetailVMInputDelegate = photoDetailVC
        
        return photoDetailVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startDownloadingImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloading(image:Data?, status:ImageDownloadState) {
        
        if status == .downloaded  {
            if let imageData = image, let currentImage = UIImage(data: imageData) {
                //sucessfull download
                self.photoImageView.image = currentImage
                self.photoInfo.text = viewModel.image.description
                viewModel.pendingForDownload = false
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        } else if status == .failed {
            //download fail
            self.photoImageView.image = #imageLiteral(resourceName: "Placeholder")
            self.photoInfo.text = viewModel.image.description
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            viewModel.pendingForDownload = true
            
        } else if status == .new {
            //show progress indicator
            self.photoImageView.image = #imageLiteral(resourceName: "Placeholder")
            self.photoInfo.text = viewModel.image.description
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            viewModel.pendingForDownload = true
        }
    }
    

}
