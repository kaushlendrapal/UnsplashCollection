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
        NetworkManager.sharedManager.setUpWithAppId(appId: "8ef42698e366832076e1ab8e822fe441141239a022dda4f1d8c07c83547d6ac6", secret: "61e99a9de0aca194722a0e0a668be33912ff97317f2a9b5a6ee0c0b4c788f06f")
        
        NetworkManager.sharedManager.authorizeFromController(controller: self) { (status, error) in
            if status {
                print("####     authorigation done    #######")
            }
        }
        
    }

}

