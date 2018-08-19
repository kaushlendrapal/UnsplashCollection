//
//  ViewController.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc @IBAction func goToUnsplashCollectionVCButtontapped(sander: Any) {
        
        let viewController = UnsplashCollectionviewController.unsplashCollectionViewControllerOnLaunch(with: UnsplashCollectionViewViewModel())
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc @IBAction func oAuthRegistrationButtontapped(sander: Any) {
        
        NetworkManager.sharedManager.authorizeFromController(controller: self) { (status, error) in
            if status {
                print("####     authorigation done    #######")
            }
        }
    }
    
    
}
