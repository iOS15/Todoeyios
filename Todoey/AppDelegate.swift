//
//  AppDelegate.swift
//  Todoey
//
//  Created by David Dörflinger on 11.01.19.
//  Copyright © 2019 David Dörflinger. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        do{
           _ = try Realm()
        } catch {
            print("could not load realm \(error)")
        }

        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
    }
}

