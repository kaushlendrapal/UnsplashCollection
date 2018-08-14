//
//  AppDelegate.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NetworkManager.sharedManager.setUpWithAppId(appId: "8ef42698e366832076e1ab8e822fe441141239a022dda4f1d8c07c83547d6ac6", secret: "61e99a9de0aca194722a0e0a668be33912ff97317f2a9b5a6ee0c0b4c788f06f")
        
        return true
    }

}

