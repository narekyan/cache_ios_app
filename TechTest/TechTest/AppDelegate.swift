//
//  AppDelegate.swift
//  TechTest
//
//  Created by Narek on 30.04.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var startCoordinator = StartCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startCoordinator.start(window?.rootViewController as? UINavigationController)
        return true
    }
}

