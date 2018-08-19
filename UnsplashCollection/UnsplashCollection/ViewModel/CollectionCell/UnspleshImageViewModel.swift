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

class UnspleshImageViewModel {
    
    var image:USImage
    weak var imageViewModelInputDelegate: UnspleshImageVMInputDelegate?
    var pendingForDownload = true

    init(unsplashedImage:USImage) {
        self.image = unsplashedImage
        self.pendingForDownload = true
    }
    
    func startDownloadingImage() {
        
        imageViewModelInputDelegate?.downloading(image: nil, status: .new)
        var imageRequest = ImageRequestBuilder(accessToken: nil)
        imageRequest.photoURLRequest(for: self.image, imageURLType: .thumb)
        NetworkQueueManager.shared.downloadImage(with: imageRequest, authRequired: false) { (imageData, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.imageViewModelInputDelegate?.downloading(image: nil, status: .failed)
                } else {
                    self.imageViewModelInputDelegate?.downloading(image: imageData as? Data, status: .downloaded )
                }
            }
        }
    }
    
}


