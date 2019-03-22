//
//  Territory+Emoji.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 27/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation

extension Territory {
    
    func emojiFlag() -> String? {
        let regionCode = code.uppercased()
        
        var flagString = ""
        for s in regionCode.unicodeScalars {
            guard let scalar = UnicodeScalar(127397 + s.value) else {
                continue
            }
            flagString.append(String(scalar))
        }
        return flagString
    }

}
