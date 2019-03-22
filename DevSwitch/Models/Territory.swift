//
//  Territory.swift
//  Storeswitch
//
//  Created by Aaron Pearce on 23/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import RealmSwift
import UIKit

class Territory: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var code: String = ""
    @objc dynamic var title: String = ""
    let keywords = List<String>()
    @objc dynamic var isFavorited: Bool = false
    @objc dynamic var lastUsedDate: Date?
    let position = RealmOptional<Int>() // Can't use Int? in realm, access with `.value`
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
