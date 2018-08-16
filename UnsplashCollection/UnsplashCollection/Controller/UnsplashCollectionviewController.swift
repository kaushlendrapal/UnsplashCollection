//
//  UnsplashCollectionviewController.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 10/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit

fileprivate struct RegisteredCellClassIdentifier {
    static let unspleshCollectionImageCell:String = "UnspleshCollectionImageCell"
    static let unsplashCollectionHeaderView:String = "UnsplashCollectionHeaderView"
    static let unsplashCollectionFooterView:String = "UnsplashCollectionFooterView"
}

class UnsplashCollectionviewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel:UnsplashCollectionViewViewModel!
    
    class func unsplashCollectionViewControllerOnLaunch(with viewModel:Any) -> (UnsplashCollectionviewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let identifier = "UnsplashCollectionviewController"
        let unsplashCollectionVC: UnsplashCollectionviewController = storyboard.instantiateViewController(withIdentifier: identifier) as! UnsplashCollectionviewController
        guard let homeViewModel = viewModel as? UnsplashCollectionViewViewModel else {
            return unsplashCollectionVC
        }
        unsplashCollectionVC.viewModel = homeViewModel
        unsplashCollectionVC.viewModel.collectionVMDelegate = unsplashCollectionVC
        
        return unsplashCollectionVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchAllImages(searchCriteria:viewModel.searchCriteria)
        setUpView()
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() -> Void {
        collectionView.register(UINib.init(nibName: RegisteredCellClassIdentifier.unspleshCollectionImageCell, bundle: Bundle.main), forCellWithReuseIdentifier: RegisteredCellClassIdentifier.unspleshCollectionImageCell)
        collectionView.register(UINib.init(nibName: RegisteredCellClassIdentifier.unsplashCollectionHeaderView, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RegisteredCellClassIdentifier.unsplashCollectionHeaderView)
        collectionView.register(UINib.init(nibName: RegisteredCellClassIdentifier.unsplashCollectionFooterView, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: RegisteredCellClassIdentifier.unsplashCollectionFooterView)
        
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 160, height: 120)
//            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }

}

extension UnsplashCollectionviewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var imageLayoutCell:UnspleshCollectionImageCell!
        imageLayoutCell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisteredCellClassIdentifier.unspleshCollectionImageCell, for: indexPath) as! UnspleshCollectionImageCell
        if let image = viewModel.getImageModel(at: indexPath) {
            let imageCellViewModel = UnspleshImageViewModel(unsplashedImage: image)
            imageLayoutCell.configureView(with: imageCellViewModel)
        }
        
        return imageLayoutCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerFooterView:UICollectionReusableView
        
        if (kind == UICollectionElementKindSectionHeader) {
            headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:RegisteredCellClassIdentifier.unsplashCollectionHeaderView, for: indexPath)
        } else if (kind == UICollectionElementKindSectionFooter) {
            headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier:RegisteredCellClassIdentifier.unsplashCollectionFooterView, for: indexPath)
        } else {
            headerFooterView = UICollectionReusableView(frame: CGRect.zero)
        }
        
        return headerFooterView
    }

}

extension UnsplashCollectionviewController {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 160, height: 120)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: Device.screenWidth, height: 50)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: Device.screenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let image = viewModel.getImageModel(at: indexPath) {
            self.showPhotoDetailViewControllerFor(image: image)
        }
    }
    
    func showPhotoDetailViewControllerFor(image:USImage)  {
        let viewModel = PhotoDetailViewModel(unsplashedImage: image)
        let viewController = PhotoDetailViewController.photoDetailViewControllerOnLaunch(with: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

//MARK: UnspleshCollectionVMInputDelegate

extension UnsplashCollectionviewController: UnspleshCollectionVMInputDelegate {
    
    func handleGeneraErrorResponse(genericError: WebServiceError) {
        //TODO: show alert with error description.
        print("### handleGeneraErrorResponse  ###")
        
    }
    
    func handleCollectionViewReloadOnDataSourceUpdate() {
        print("### handleCollectionViewReloadOnDataSourceUpdate  ###")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}



