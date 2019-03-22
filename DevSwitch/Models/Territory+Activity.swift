//
//  Territory+Activity.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 27/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import Intents

let TerritoryActivityType = "com.aaronpearce.StoreSwitch.TerritoryActivityType"

extension Territory {
    var activity: NSUserActivity {
        let activity = NSUserActivity(activityType: TerritoryActivityType)
        
        let phrase = "Switch to the \(title) storefront"
        activity.title = phrase
        
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(TerritoryActivityType)
            activity.isEligibleForPrediction = true
            activity.suggestedInvocationPhrase = phrase
        }
        
        activity.isEligibleForSearch = true
        
        activity.userInfo = ["code": code]
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = UIImage(named: code.uppercased())?.pngData()
        activity.contentAttributeSet = attributes
        
        
        return activity
    }
}
