//
//  PhotoDetailViewModel.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 14/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

protocol PhotoDetailVMInputDelegate: class {
    func downloading(image:Data?, status:ImageDownloadState)
}

class PhotoDetailViewModel {
    
    var image:USImage
    weak var photoDetailVMInputDelegate: PhotoDetailVMInputDelegate?
    var pendingForDownload = true
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
    
    
    init(unsplashedImage:USImage) {
        self.image = unsplashedImage
        self.pendingForDownload = true
    }
    
    func startDownloadingImage() {
        photoDetailVMInputDelegate?.downloading(image: nil, status: .new)
        let imageDownloadOperation = ImageDownloader(image, imageURLType: .regular, accessToken: NetworkManager.sharedManager.unsplashToken!) { (imageData, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.photoDetailVMInputDelegate?.downloading(image: nil, status: .failed)
                } else {
                    self.photoDetailVMInputDelegate?.downloading(image: imageData as? Data, status: .downloaded)
                }
            }
        }
        imageDownloadOperation.name = String("ImageDownloader")
        downloadQueue.addOperation(imageDownloadOperation)
    }
    
}