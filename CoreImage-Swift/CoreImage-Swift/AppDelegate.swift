//
//  AppDelegate.swift
//  CoreImage-Swift
//
//  Created by 苏沫离 on 2017/9/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let vc = ViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        window.rootViewController = nav
        
        return true
    }
}

