//
//  AppDelegate.swift
//  Storeswitch
//
//  Created by Aaron Pearce on 23/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var shortcutItemToProcess: UIApplicationShortcutItem?
    var launchedURL: URL?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var shouldPerformAdditionalDelegateHandling = true
        
        setAppearances()
        realmSetup()
        
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.delegate = self
            
            if let lastUsedTabBarIndex = UserDefaults.standard.object(forKey: "LastUsedTabBarIndex") as? Int {
                tabBarController.selectedIndex = lastUsedTabBarIndex
            }
        }
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
            shouldPerformAdditionalDelegateHandling = false
        }
        
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            launchedURL = url
            shouldPerformAdditionalDelegateHandling = false
        }
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard tabBarController.selectedIndex != 3 else { return }
        UserDefaults.standard.set(tabBarController.selectedIndex, forKey: "LastUsedTabBarIndex")
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Alternatively, a shortcut item may be passed in through this delegate method if the app was
        // still in memory when the Home screen quick action was used. Again, store it for processing.
        shortcutItemToProcess = shortcutItem
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Is there a shortcut item that has not yet been processed?
        if let shortcutItem = shortcutItemToProcess {
            // In this sample an alert is being shown to indicate that the action has been triggered,
            // but in real code the functionality for the quick action would be triggered.
            if shortcutItem.type == "OpenFavoriteStoreAction" {
                if let code = shortcutItem.userInfo?["code"] as? String {
                    open(for: code)
                }
            }
            
            // Reset the shorcut item so it's never processed twice.
            shortcutItemToProcess = nil
        }
        
        if let url = launchedURL {
            _ = handle(url: url)
            launchedURL = nil
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == TerritoryActivityType {
            if let code = userActivity.userInfo?["code"] as? String {
                open(for: code)
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handle(url: url)
    }
    
    private func handle(url: URL) -> Bool {
        var handled = false
        
        if url.host == "open" {
            
            if let code = url.pathComponents.last {
                open(for: code)
                handled = true
            }
        }
        
        return handled
    }
    
    private func open(for code: String) {
        if let realm = try? Realm(),
            let territory = realm.objects(Territory.self).filter("code == %@", code).first {
            territory.open()
        }
    }
    
    private func realmSetup() {
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL?.path
        let path = Bundle.main.path(forResource: "default-territories", ofType: "realm")
        if !FileManager.default.fileExists(atPath: defaultPath!), let bundledPath = path {
            do {
                try FileManager.default.copyItem(atPath: bundledPath, toPath: defaultPath!)
            } catch {
                print("Error copying pre-populated Realm \(error)")
            }
        }
        
        let config = Realm.Configuration(
            
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 4,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    private func setAppearances() {
        window?.tintColor = UIColor(named: "primary")
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "primary")!]
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Transform each favorite territory into a UIApplicationShortcutItem.
        guard let realm = try? Realm() else { return }
        
        let favoriteSortProperties = [
            SortDescriptor(keyPath: "position", ascending: false),
            SortDescriptor(keyPath: "title", ascending: true)
        ]
        
        let territories: [Territory] = realm.objects(Territory.self).filter("isFavorited == true").sorted(by: favoriteSortProperties).get(offset: 0, limit: 5)
        application.shortcutItems = territories.map { territory -> UIApplicationShortcutItem in
            let userInfo = [ "code": territory.code as NSSecureCoding ]
            return UIApplicationShortcutItem(type: "OpenFavoriteStoreAction",
                                             localizedTitle: territory.title,
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(type: .favorite),
                                             userInfo: userInfo)
        }
    }

    
}

