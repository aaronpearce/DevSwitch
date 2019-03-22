//
//  VoiceShortcutsViewController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 1/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

@available (iOS 12.0, *)
class VoiceShortcutsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        title = "Siri Shortcuts".localized
        
        view.backgroundColor = UIColor("#F0EFF5")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVoiceShortcut(_:)))
        
        VoiceShortcutsManager.shared.updateVoiceShortcuts { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func addVoiceShortcut(_ barButtonItem: UIBarButtonItem) {
        // Pop up storefront selector view
        // Then show add view
        let layout = UICollectionViewFlowLayout()
        
        
        let pickerViewController = TerritoriesPickerCollectionViewController(collectionViewLayout: layout)
        pickerViewController.didPickTerritory = { [weak self] territory in
            self?.createVoiceShortcut(for: territory)
        }
        
        present(pickerViewController.embedInNav(), animated: true)
    }
    
    private func createVoiceShortcut(for territory: Territory) {
        let shortcut = INShortcut(userActivity: territory.activity)
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.modalPresentationStyle = .formSheet
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VoiceShortcutsManager.shared.voiceShortcuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ListCell
        
        let voiceShortcut = VoiceShortcutsManager.shared.voiceShortcuts[indexPath.item]
        cell.configure(title: voiceShortcut.invocationPhrase, subtitle: voiceShortcut.shortcut.userActivity?.title)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // depends on the cell
        let voiceShortcut = VoiceShortcutsManager.shared.voiceShortcuts[indexPath.item]
        let viewController = INUIEditVoiceShortcutViewController(voiceShortcut: voiceShortcut)
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = collectionView.bounds.width
        return CGSize(width: screenWidth - (padding * 2), height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as SettingsFooterView
            footer.titleLabel.text = "You do not have any Siri Shortcuts yet."
            return footer
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if VoiceShortcutsManager.shared.voiceShortcuts.isEmpty {
            return CGSize(width: 0, height: 15)
        }
        
        return .zero
    }
}

@available(iOS 12.0, *)
extension VoiceShortcutsViewController: INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        // Update the tableview
        if let error = error {
            print(error)
        }
        
        updateVoiceShortcuts()
        controller.dismiss(animated: true)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        // Nothing?
        controller.dismiss(animated: true)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error {
            print(error)
        }
        
        updateVoiceShortcuts()
        controller.dismiss(animated: true)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        updateVoiceShortcuts()
        controller.dismiss(animated: true)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
    
    func updateVoiceShortcuts() {
        VoiceShortcutsManager.shared.updateVoiceShortcuts { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}
