//
//  AppSearchViewController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 5/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

typealias AppSearchViewControllerDidSelectResult = ((AppSearchResult) -> ())
class AppSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var didSelect: AppSearchViewControllerDidSelectResult?
    var results = [String]()
    let padding: CGFloat = 16
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).usingAutoLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "background")
        collectionView.register(cellType: ListCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInsetReference = .fromSafeArea
        layout.sectionInset = UIEdgeInsets(top: 12, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }()
    
    lazy var searchController: NoCancelButtonSearchController = {
        let searchController = NoCancelButtonSearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search".localized
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        return searchController
    }()
    
    let dataSource = AppSearchDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.constraintsToFit(view: view))
    
        view.backgroundColor = UIColor(named: "background")
        navigationItem.titleView = searchController.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }
    
    @objc func close() {
        if searchController.isActive {
            searchController.dismiss(animated: true, completion: {
                self.dismiss(animated: true)
            })
        } else {
            dismiss(animated: true)
        }
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchController.searchBar.setShowsCancelButton(false, animated: false)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfRows(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ListCell
        
        if let result = dataSource.result(for: indexPath) {
            let imageView = UIImageView().usingAutoLayout()
            imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
            imageView.kf.setImage(
                with: result.artworkUrl100
            )
            
            cell.configure(title: result.trackName, subtitle: result.sellerName, leftAccessoryView: imageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let result = dataSource.result(for: indexPath) else { return }
        didSelect?(result)
        close()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = collectionView.bounds.width
        return CGSize(width: screenWidth - (padding * 2), height: 64)
    }
}


extension AppSearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text, scope: searchController.searchBar.selectedScopeButtonIndex)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String?, scope: Int = 0) {
        dataSource.search(for: searchText) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
