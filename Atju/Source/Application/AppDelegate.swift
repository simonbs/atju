//
//  AppDelegate.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import UIKit
import AirshipKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let navigationController = NavigationController(rootViewController: ReadingsViewController())
        navigationController.navigationBar.barTintColor = UIColor(hex: 0x232323)
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.isTranslucent = false
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.tintColor = .black
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        configureUrbanAirship()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func configureUrbanAirship() {
        if UAirship.sbs_isConfigAvailable {
            UAirship.takeOff()
            UAirship.push().tags = [ SettingsStore().selectedCity.title ]
            UAirship.push().userPushNotificationsEnabled = true
        }
    }
}

