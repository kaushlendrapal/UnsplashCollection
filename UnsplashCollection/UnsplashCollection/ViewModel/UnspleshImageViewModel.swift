//
//  UnspleshImageViewModel.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

protocol UnspleshImageVMInputDelegate: class {
    func downloading(image:Data?, status:ImageDownloadState)
}

class UnspleshImageViewModel: BaseViewModel {
    
    var image:USImage
    weak var imageViewModelInputDelegate: UnspleshImageVMInputDelegate?
    var pendingForDownload = true
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
    

    init(unsplashedImage:USImage) {
        self.image = unsplashedImage
        self.pendingForDownload = true
        super.init()
    }
    
    func startDownloadingImage() {
        imageViewModelInputDelegate?.downloading(image: nil, status: .new)
        let imageDownloadOperation = ImageDownloader(image, imageURLType: .thumb, accessToken: NetworkManager.sharedManager.unsplashToken!) { (imageData, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.imageViewModelInputDelegate?.downloading(image: nil, status: .failed)
                } else {
                    self.imageViewModelInputDelegate?.downloading(image: imageData as? Data, status: .downloaded )
                }
            }
        }
        imageDownloadOperation.name = String("ImageDownloader")
        downloadQueue.addOperation(imageDownloadOperation)
    }
    
}


