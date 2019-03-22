//
//  AnywhereAlertController.swift
//  DevSwitch
//
//  Created by Aaron on 9/01/18.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit

class AnywhereAlertController: UIAlertController {
    
    var alertWindow: UIWindow?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        alertWindow?.isHidden = true
        alertWindow = nil
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func show(animated: Bool = true) {
        let blankViewController = UIViewController()
        blankViewController.view.backgroundColor = .clear
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = blankViewController
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        
        self.alertWindow = window
        
        blankViewController.present(self, animated: animated)
    }
    
    class func showWithOkay(title: String?, message: String?) {
        let alertController = AnywhereAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK".localized, style: .default))
        alertController.show()
    }
}
