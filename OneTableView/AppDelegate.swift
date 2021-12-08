//
//  AppDelegate.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/11/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }

}

