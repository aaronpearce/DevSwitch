//
//  TerritoriesCollectionViewController.swift
//  Storeswitch
//
//  Created by Aaron Pearce on 23/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FavoriteTerritoriesCollectionViewController: TerritoriesCollectionViewController {
    override func createDataSource() -> DataSource {
        return FavoriteDataSource(collectionView: collectionView)
    }
    
    override var isSearchEnabled: Bool {
        return false
    }
}

class AllTerritoriesCollectionViewController: TerritoriesCollectionViewController {
    override func createDataSource() -> DataSource {
        return CountriesDataSource(collectionView: collectionView)
    }
    
    override var isSearchEnabled: Bool {
        return true
    }
}

class TerritoriesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search".localized
//        searchController.searchBar.scopeButtonTitles = ["All".localized, "Home".localized, "Room".localized]
        return searchController
    }()

    lazy var dataSource: DataSource = {
        return createDataSource()
    }()
    
    func createDataSource() -> DataSource {
         return CountriesDataSource(collectionView: collectionView)
    }
    
    var isSearchEnabled: Bool {
        return true
    }
    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(longPressPerformed(_:)))
    }()
    
    lazy var forceTouchGesture: ForceTouchGestureRecognizer = {
        return ForceTouchGestureRecognizer(target: self, action: #selector(forcePressPerformed(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
        }
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(named: "background")
        collectionView.register(cellType: TerritoryCell.self)
        collectionView.register(supplementaryViewType: TerritoryHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: TerritoryFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)

        if isSearchEnabled {
            definesPresentationContext = true
            navigationItem.searchController = searchController
        }

        dataSource.updateTokens()
        
        setupGestures()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupGestures()
    }
    
    func setupGestures() {
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            collectionView.removeGestureRecognizer(longPressGesture)
            collectionView.addGestureRecognizer(forceTouchGesture)
        } else  {
            // When force touch is not available, remove force touch gesture recognizer.
            // Also implement a fallback if necessary (e.g. a long press gesture recognizer)
            collectionView.addGestureRecognizer(longPressGesture)
            collectionView.removeGestureRecognizer(forceTouchGesture)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfRows(for: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TerritoryCell
    
        if let territory = dataSource.territory(for: indexPath) {
            if self is FavoriteTerritoriesCollectionViewController, indexPath.section == 0  {
                cell.configure(with: territory, showFavorites: false)
            } else {
                cell.configure(with: territory)
            }
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let territory = dataSource.territory(for: indexPath) else { return }
        
        territory.open()
    }

    let padding: CGFloat = 16
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        let screenWidth: CGFloat = collectionView.bounds.width
        if traitCollection.horizontalSizeClass == .regular {
            let perRow: CGFloat = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? 4 : 2
            width = ( screenWidth - (padding * (perRow + 1)) ) / perRow
        } else {
            let perRow: CGFloat = 2
            width = ( screenWidth - (padding * (perRow + 1)) ) / perRow
        }
        
        return CGSize(width: width, height: 64)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = dataSource.header(for: indexPath.section), kind == UICollectionView.elementKindSectionHeader {
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as TerritoryHeaderView
            
            supplementaryView.titleLabel.text = header
            
            return supplementaryView
        } else if var footer = dataSource.footer(for: indexPath.section), kind == UICollectionView.elementKindSectionFooter {
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as TerritoryFooterView
            if footer == FavoriteDataSource.emptyStatePlaceholder {
                var favoriteActionText = "long press".localized
                if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    favoriteActionText = "3D Touch".localized
                }
                footer = "To favourite a storefront, \(favoriteActionText) the storefront."
            }
            supplementaryView.titleLabel.text = footer
            return supplementaryView
        }
        
        return collectionView.supplementaryView(forElementKind: kind, at: indexPath)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataSource.header(for: section) != nil {
            return CGSize(width: 0, height: 32)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if dataSource.footer(for: section) != nil {
            return CGSize(width: 0, height: 32)
        }
        
        return .zero
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc func forcePressPerformed(_ gesture: ForceTouchGestureRecognizer) {
        
        switch(gesture.state) {
            
        case .recognized:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            
            toggleFavorite(for: selectedIndexPath)
        default:
            break
        }
    }
    @objc func longPressPerformed(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            
            toggleFavorite(for: selectedIndexPath)
            
        default:
            break
        }
    }
    
    private func toggleFavorite(for indexPath: IndexPath) {
        guard let territory = dataSource.territory(for: indexPath) else { return }
        
        Haptic.impact(.heavy).generate()
        
        if let realm = try? Realm() {
            try? realm.write {
                territory.isFavorited = !territory.isFavorited
            }
        }
    }
}

extension TerritoriesCollectionViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text, scope: searchController.searchBar.selectedScopeButtonIndex)
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String?, scope: Int = 0) {
        dataSource.filterTerritories(for: searchText)
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
