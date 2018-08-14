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


struct SearchCriteria {
    var page:Int = Int(5)
    var perPage:Int
    var orderBy:String
    var orientation:String
    var searchText:String = "india"
    
    
    init(perPage:Int, orderBy:String, orientation:String, searchText:String) {
        self.perPage = perPage
        self.orderBy = orderBy
        self.orientation = orientation
    }
    
}

class UnsplashCollectionViewViewModel: BaseViewModel {
    var collectionDataSource:[USImage]?
    var networkManager = NetworkManager()
    weak var collectionVMDelegate:UnspleshCollectionVMInputDelegate?
    var searchCriteria = SearchCriteria(perPage: 20, orderBy: "popular", orientation: "squarish", searchText: "Nature")
    
    func fetchAllImages(searchCriteria:SearchCriteria)  {
        let requestParamaters:[String: Any] = ["page": Int(5), "per_page": searchCriteria.perPage, "order_by": searchCriteria.orderBy, "orientation": searchCriteria.orientation, "query": searchCriteria.searchText]
        
        NetworkQueueManager.shared.makeNetworkCall(requestHelper: requestParamaters) { (jsonObject, error) in
            let jsonResult = self.handleJSONResponse(responseObject: jsonObject, httpError: error, ofResultType: [USImage].self)
            switch jsonResult {
            case JSONResult.failure(let genericError):
                print("")
                self.collectionVMDelegate?.handleGeneraErrorResponse(genericError: genericError)
            case JSONResult.success(let images):
                self.collectionDataSource = images
                self.collectionVMDelegate?.handleCollectionViewReloadOnDataSourceUpdate()
            case JSONResult.successWithResult( _):
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
    
    func getImageModel(at indexPath:IndexPath) -> USImage? {
        guard let dataSource = collectionDataSource, indexPath.row < dataSource.count else {
            return nil
        }
        return dataSource[indexPath.row]
    }
    
}
