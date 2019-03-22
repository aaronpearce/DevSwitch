//
//  App.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 5/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import RealmSwift
import UIKit

class App: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var sellerName: String = ""
    @objc dynamic var artworkUrlString: String = ""
    @objc dynamic var appId: Int = 0
    
    override class func primaryKey() -> String? {
        return "appId"
    }
}
