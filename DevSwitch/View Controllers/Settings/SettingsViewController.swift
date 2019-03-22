//
//  SettingsViewController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 26/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import DeviceKit

class SettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let padding: CGFloat = 16
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).usingAutoLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor("#F0EFF5")
        collectionView.register(cellType: ListCell.self)
        collectionView.register(supplementaryViewType: SettingsFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.constraintsToFit(view: view))
        
        title = "Settings".localized
        
        view.backgroundColor = UIColor("#F0EFF5")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if #available(iOS 12.0, *) {
                return 2
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ListCell
        
        switch (indexPath.section, indexPath.item) {
        case (0, 0):
            cell.configure(title: "Guide".localized, subtitle: nil, rightAccessoryView: chevronRightIconView())
        case (0, 1):
            cell.configure(title: "Siri Shortcuts".localized, subtitle: nil, rightAccessoryView: chevronRightIconView())
        default:
            break
        }
        
        cell.accessibilityHint = "Double tap".localized
        
        return cell
    }
    
    func chevronRightIconView() -> UIImageView {
        let icon = UIImageView(image: UIImage(named: "chevron-line-right"))
        icon.tintColor = .gray
        return icon
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // depends on the cell
        switch (indexPath.section, indexPath.item) {
        case (0, 0):
            let controller = HowItWorksViewController()
            navigationController?.pushViewController(controller, animated: true)
        case (0, 1):
            if #available(iOS 12.0, *) {
                let controller = VoiceShortcutsViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = collectionView.bounds.width
        return CGSize(width: screenWidth - (padding * 2), height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as SettingsFooterView
            footer.titleLabel.text = String.localizedStringWithFormat("Version %@ (%@)", Bundle.main.releaseVersionNumber ?? "", Bundle.main.buildVersionNumber ?? "")
            return footer
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == collectionView.numberOfSections - 1 {
            return CGSize(width: 0, height: 15)
        }
        
        return .zero
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}
