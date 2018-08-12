//
//  UnspleshImageViewModel.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

protocol UnspleshImageVMInputDelegate: class {
    func imageDownloadedSucessfully(with image:USImage?, status:ImageDownloadState)
}

class UnspleshImageViewModel: BaseViewModel {
    
    var image:USImage
    weak var imageViewModelInputDelegate: UnspleshImageVMInputDelegate?

    init(unsplashedImage:USImage) {
        self.image = unsplashedImage
        super.init()
    }
    
    func startDownloadingImage() {
        
    }
    
}
