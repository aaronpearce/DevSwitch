//
//  CountriesDataSource.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 26/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import RealmSwift

class CountriesDataSource: DataSource {
    var collectionView: UICollectionView
    
    let sortProperties = [
        SortDescriptor(keyPath: "position", ascending: false),
        SortDescriptor(keyPath: "title", ascending: true)
    ]
    
    lazy var territories: Results<Territory> = {
        let realm = try! Realm()
        return realm.objects(Territory.self).sorted(by: sortProperties)
    }()

    var token: NotificationToken?
    
    required init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func updateTokens() {
        token?.invalidate()

        token = territories.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update( _, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                }, completion: nil)
                
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(for section: Int) -> Int {
        return territories.count
    }
    
    func territory(for indexPath: IndexPath) -> Territory? {
        return territories[indexPath.item]
    }
    
    func filterTerritories(for keyword: String?) {
        let realm = try! Realm()
        territories = realm.objects(Territory.self).sorted(by: sortProperties)
        if let keyword = keyword, !keyword.isEmpty {
            let predicate = NSPredicate(format: "title CONTAINS[c] %@ || code CONTAINS[c] %@", keyword, keyword)
            territories = territories.filter(predicate)
        }
        
        updateTokens()
    }
    
    func header(for section: Int) -> String? {
        return nil
    }
    
    func footer(for section: Int) -> String? {
        return nil
    }
}

