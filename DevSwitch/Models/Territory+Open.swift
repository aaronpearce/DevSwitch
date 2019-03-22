//
//  Territory+Open.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 27/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import RealmSwift

extension Territory {
    func open() {
        if let storeURL = URLBuilder.url(for: code) {
            
            UIApplication.shared.userActivity = activity
            UIApplication.shared.userActivity?.becomeCurrent()
            
            if let realm = try? Realm() {
                try? realm.write {
                    self.lastUsedDate = Date()
                }
            }
            
            // We delay by 100ms to let the user activity take hold.
            let deadlineTime = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
            }
        }
    }
}
