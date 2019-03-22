//
//  UIViewController+Embed.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 7/05/18.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedInNav() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
