//
//  UnsplashCollectionViewViewModel.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 11/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

protocol UnspleshCollectionVMInputDelegate: class {
    func handleGeneraErrorResponse(genericError: WebServiceError)
    func handleCollectionViewReloadOnDataSourceUpdate()
}

class UnsplashCollectionViewViewModel: BaseViewModel {
    var collectionDataSource:[USImage]?
    var networkManager = NetworkManager()
    weak var collectionVMDelegate:UnspleshCollectionVMInputDelegate?
    
    
    func fetchAllImages()  {
        let requestParamaters:[String: Any] = ["page": Int(1), "per_page": Int(20), "order_by": "popular", "orientation": "squarish", "query": "india"]
        NetworkQueueManager.shared.makeNetworkCall(requestHelper: requestParamaters) { (jsonObject, error) in
            let jsonResult = self.handleJSONResponse(responseObject: jsonObject, httpError: error, ofResultType: [USImage].self)
            switch jsonResult {
            case JSONResult.failure(let genericError):
                print("")
                self.collectionVMDelegate?.handleGeneraErrorResponse(genericError: genericError)
            case JSONResult.success(let images):
                self.collectionDataSource = images
                self.collectionVMDelegate?.handleCollectionViewReloadOnDataSourceUpdate()
            case JSONResult.successWithResult(let resultInfo):
                print("")
            default:
                print("")
            }
        }
        
    }
    
    func numberOfSection() -> Int {
        return 2
    }
    
    func numberOfItemsInSection(section:Int) -> Int {
        
        guard let dataSource = collectionDataSource else {
          return 0
        }
        
        return dataSource.count
    }
    
    func getImage(at indexPath:IndexPath) -> USImage? {
        guard let dataSource = collectionDataSource, indexPath.row < dataSource.count else {
            return nil
        }
        return dataSource[indexPath.row]
    }
    
}
