//
//  TerritoriesPickerCollectionViewController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 1/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit

typealias TerritoriesPickerDidPickTerritory = ((Territory) -> ())
class TerritoriesPickerCollectionViewController: TerritoriesCollectionViewController {
    
    var didPickTerritory: TerritoriesPickerDidPickTerritory?
    
    override var isSearchEnabled: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose Country".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
    }
    
    @objc func cancel(_ barButtonItem: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let territory = dataSource.territory(for: indexPath) else { return }
        
        dismiss(animated: true)
        didPickTerritory?(territory)
    }
}
