//
//  AppDelegate.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 20/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent

        window = UIWindow(frame: UIScreen.main.bounds)
        let searchViewController = SearchTableViewController()
        let navController = BaseNavigationController(rootViewController: searchViewController)
        
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        
        return true
    }
}

