//
//  BaseViewController.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

/******************************************************************************
 * BaseViewController: base controller for all custom controller will hold the comman reusable
 * functionality
 ******************************************************************************/

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBarItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBarItems() -> Void {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
}
