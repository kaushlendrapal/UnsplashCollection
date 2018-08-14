//
//  DesignDisplayViewController.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 14/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

class DesignDisplayViewController: BaseViewController {

    var designImages: [UIImage] = []
    var viewModel:DesignDisplayViewModel!
    var currentImage = "firstFlow"
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    class func designDisplayViewControllerOnLaunch(with viewModel:Any) -> (DesignDisplayViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let identifier = "DesignDisplayViewController"
        let designDisplayVC: DesignDisplayViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! DesignDisplayViewController
        guard let designDisplayViewModel = viewModel as? DesignDisplayViewModel else {
            return designDisplayVC
        }
        designDisplayVC.viewModel = designDisplayViewModel
        
        return designDisplayVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentImage = self.viewModel.getFirstImageName()
        self.photoImageView.image = UIImage(named: currentImage)!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    
    @IBAction func nextButtonTapped(sander: Any) {
        currentImage = self.viewModel.nameOfImageNextTo(image: currentImage)
        self.photoImageView.image = UIImage(named: currentImage)!
    }
    
     @IBAction func previousButtonTapped(sander: Any) {
        currentImage = self.viewModel.nameOfImagePriorTo(image: currentImage)
        self.photoImageView.image = UIImage(named: currentImage)!

    }

}
