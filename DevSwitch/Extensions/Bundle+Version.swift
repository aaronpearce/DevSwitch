//
//  Bundle+Version.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 26/10/17.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }
}
