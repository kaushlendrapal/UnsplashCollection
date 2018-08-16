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
    
    
    init(unsplashedImage:USImage) {
        self.image = unsplashedImage
        self.pendingForDownload = true
    }
    
    func startDownloadingImage() {
        photoDetailVMInputDelegate?.downloading(image: nil, status: .new)
            var imageRequest = ImageRequestBuilder(accessToken: nil)
            imageRequest.photoURLRequest(for: self.image, imageURLType: .regular)
        NetworkQueueManager.shared.downloadImage(with: imageRequest, authRequired: false) { (imageData, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.photoDetailVMInputDelegate?.downloading(image: nil, status: .failed)
                    } else {
                        self.photoDetailVMInputDelegate?.downloading(image: imageData as? Data, status: .downloaded)
                    }
                }
            }
    }
    
}
