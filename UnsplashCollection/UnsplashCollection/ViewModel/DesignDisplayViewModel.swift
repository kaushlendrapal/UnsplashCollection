//
//  DesignDisplayViewModel.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 14/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation

class DesignDisplayViewModel: BaseViewModel {
    
    var designImages: [String]
    
    init(images:[String]) {
        self.designImages = images
    }
    
    func nameOfImageNextTo(image:String) -> String {
        var imageName:String
        guard let imageIndex = self.designImages.index(of: image) else {
            return ""
        }
        
        if imageIndex == (designImages.endIndex - 1) {
            imageName = designImages.first!
        } else {
            imageName = designImages[imageIndex + 1]
        }
        
        return imageName
    }
    
    func nameOfImagePriorTo(image:String) -> String {
        var imageName:String
        guard let imageIndex = self.designImages.index(of: image) else {
            return ""
        }
        
        if imageIndex == designImages.startIndex {
            imageName = designImages.last!
        } else {
            imageName = designImages[imageIndex - 1]
        }
        
        return imageName
    }
    
    func getFirstImageName() -> String {
        return designImages.first!
    }
    
    
}
