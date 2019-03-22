//
//  NoCancelButtonSearchController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 21/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit

class NoCancelButtonSearchController: UISearchController {
    lazy var _searchBar: NoCancelButtonSearchBar = {
        [unowned self] in
        let customSearchBar = NoCancelButtonSearchBar(frame: CGRect.zero)
        return customSearchBar
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}
