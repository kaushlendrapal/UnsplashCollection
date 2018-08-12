//
//  USPhotoDownload.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
import UIKit

enum ImageDownloadState {
    case new, downloaded, failed
}

class USPhotoDownload {
    let name: String
    let url: URL
    var state = ImageDownloadState.new
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
    
    
}
