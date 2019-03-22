//
//  DataSource.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 26/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import RealmSwift

protocol DataSource {
    init(collectionView: UICollectionView)
    var collectionView: UICollectionView { get set }
    func updateTokens()
    
    var numberOfSections: Int { get }
    func numberOfRows(for section: Int) -> Int
    func territory(for indexPath: IndexPath) -> Territory?
    func header(for section: Int) -> String?
    func footer(for section: Int) -> String?
    
    func filterTerritories(for keyword: String?)
}

extension DataSource {
    func filterTerritories(for keyword: String?) {}
}
