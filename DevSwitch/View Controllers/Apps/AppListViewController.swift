//
//  AppListViewController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 5/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import Reusable
import RealmSwift
import SwipeCellKit

class AppListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    lazy var dataSource: AppListDataSource = {
        return AppListDataSource(collectionView: collectionView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.constraintsToFit(view: view))
        
        title = "Apps".localized
        
        view.backgroundColor = UIColor(named: "background")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchForApp(_:)))
    }
    
    @objc private func searchForApp(_ barButtonItem: UIBarButtonItem) {
        let searchViewController = AppSearchViewController()
        searchViewController.didSelect = { result in
            let app = App()
            app.name = result.trackName
            app.appId = result.trackId
            app.sellerName = result.sellerName
            app.artworkUrlString = result.artworkUrl100.absoluteString
            
            if let realm = try? Realm() {
                try? realm.write {
                    realm.add(app)
                    self.collectionView.reloadData()
                }
            }
        }

        present(searchViewController.embedInNav(), animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfRows(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ListCell
        cell.delegate = self
        if let app = dataSource.app(for: indexPath) {
            let imageView = UIImageView().usingAutoLayout()
            imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
            imageView.kf.setImage(
                with: URL(string: app.artworkUrlString)!
            )

            cell.configure(title: app.name, subtitle: app.sellerName, leftAccessoryView: imageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let app = dataSource.app(for: indexPath),
            let appURL = URLBuilder.url(forApp: app.appId)
            else {
                return
        }
        
        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = collectionView.bounds.width
        return CGSize(width: screenWidth - (padding * 2), height: 64)
    }
}

extension AppListViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            // handle action by updating model with deletion
            if let app = self?.dataSource.app(for: indexPath), let realm = try? Realm() {
                try? realm.write {
                    realm.delete(app)
                }
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "circle-delete")?.withRenderingMode(.alwaysTemplate)
        deleteAction.backgroundColor = .clear
        deleteAction.textColor = UIColor("#ff2d55")
        deleteAction.font = .systemFont(ofSize: 13)
        deleteAction.transitionDelegate = ScaleTransition.default
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .reveal
        options.buttonSpacing = 4
        options.backgroundColor = .clear
        return options
    }
}
