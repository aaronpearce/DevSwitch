//
//  NoCancelButtonSearchBar.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 21/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit

class NoCancelButtonSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: animated)
    }
}

