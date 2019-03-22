//
//  URLBuilder.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 27/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation

class URLBuilder {
    static func url(for code: String) -> URL? {
        var urlString = "https://itunes.apple.com/\(code)/app"
        
        // If iOS 12 then do nothing, else append an id
        if #available(iOS 12.0, *) {} else {
            // handle older versions
            urlString.append("/a/id1")
        }
        
        return URL(string: urlString)
    }
    
    static func url(forApp appIdentifier: Int) -> URL? {
        let urlString = "https://itunes.apple.com/app/id\(appIdentifier)"
        
        return URL(string: urlString)
    }
}
