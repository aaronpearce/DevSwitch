//
//  FavoritesDataSource.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 26/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import RealmSwift


class FavoriteDataSource: DataSource {
    static let emptyStatePlaceholder = "FAV_EMPTY_STATE_PLACEHOLDER"
    var collectionView: UICollectionView

    let favoriteSortProperties = [
        SortDescriptor(keyPath: "position", ascending: false),
        SortDescriptor(keyPath: "title", ascending: true)
    ]
    
    lazy var favoritedTerritories: Results<Territory> = {
        let realm = try! Realm()
        return realm.objects(Territory.self).filter("isFavorited == true").sorted(by: favoriteSortProperties)
    }()
    
    var favoritedToken: NotificationToken?
    
    let recentlyUsedSortProperties = [
        SortDescriptor(keyPath: "lastUsedDate", ascending: false)
    ]
    
    lazy var recentlyUsedTerritories: Results<Territory> = {
        let realm = try! Realm()
        return realm.objects(Territory.self).filter("lastUsedDate != nil && isFavorited == false").sorted(by: recentlyUsedSortProperties)
    }()
    
    var recentlyUsedToken: NotificationToken?
    
    required init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func updateTokens() {
        favoritedToken?.invalidate()
        
        favoritedToken = favoritedTerritories.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, _, _, _):
                collectionView.performBatchUpdates({
                    collectionView.reloadSections([0, 1])
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
        
        recentlyUsedToken?.invalidate()
        
        recentlyUsedToken = recentlyUsedTerritories.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, _, _, _):
                collectionView.performBatchUpdates({
                    collectionView.reloadSections([0, 1])
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(for section: Int) -> Int {
        switch section {
        case 0:
            return favoritedTerritories.count
        case 1:
            return min(6, recentlyUsedTerritories.count)// ALways up to size, never more
        default:
            return 0
        }
    }
    
    func territory(for indexPath: IndexPath) -> Territory? {
        switch indexPath.section {
        case 0:
            return favoritedTerritories[indexPath.item]
        case 1:
            return recentlyUsedTerritories[indexPath.item]
        default:
            return nil
        }
    }
    
    func header(for section: Int) -> String? {
        return (section == 1 && !recentlyUsedTerritories.isEmpty) ? "Recently Used" : nil
    }
    
    func footer(for section: Int) -> String? {
        return (section == 0 && favoritedTerritories.isEmpty) ? FavoriteDataSource.emptyStatePlaceholder : nil
    }
}
