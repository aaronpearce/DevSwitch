//
//  String+Localized.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 18/10/17.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
}
