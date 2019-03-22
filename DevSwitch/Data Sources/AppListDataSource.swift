//
//  AppListDataSource.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 5/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation
import RealmSwift

class AppListDataSource {
    var collectionView: UICollectionView
    
//    let sortProperties = [
//        SortDescriptor(keyPath: "position", ascending: false),
//        SortDescriptor(keyPath: "title", ascending: true)
//    ]
    
    lazy var apps: Results<App> = {
        let realm = try! Realm()
        return realm.objects(App.self) //.sorted(by: sortProperties)
    }()
    
    var token: NotificationToken?
    
    required init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func updateTokens() {
        token?.invalidate()
        
        token = apps.observe { [weak self] (changes: RealmCollectionChange) in
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
        return apps.count
    }
    
    func app(for indexPath: IndexPath) -> App? {
        return apps[indexPath.item]
    }
}

