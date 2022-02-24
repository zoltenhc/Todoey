//
//  AppDelegate.swift
//  Todoey
//
//  Created by Zoltán Gál
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
            
        }catch{
            print(error)
            
        }
        
        return true
    }

  
    }
