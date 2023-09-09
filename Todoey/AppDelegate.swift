//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        
        
        do {
            let realm = try Realm()
        }catch {
            print("Error initializing new realm, \(error)")
        }
        
        
        
        
        return true
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        
        
    }
    
    
    // MARK: - Core Data stack
    
}
