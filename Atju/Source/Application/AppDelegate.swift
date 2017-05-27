//
//  AppDelegate.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import UIKit
import AirshipKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UAPushNotificationDelegate {
    var window: UIWindow?
    private var backgroundTasks: [UUID: UIBackgroundTaskIdentifier] = [:]
    
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
        guard UAirship.sbs_isConfigAvailable else { return }
        UAirship.takeOff()
        UAirship.push().pushNotificationDelegate = self
        UAirship.push().tags = [ SettingsStore().selectedCity.title ]
        UAirship.push().userPushNotificationsEnabled = true
    }
    
    fileprivate func startBackgroundTask(with uuid: UUID) {
        let identifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask(with: uuid)
        }
        backgroundTasks[uuid] = identifier
    }
    
    fileprivate func endBackgroundTask(with uuid: UUID) {
        guard let identifier = backgroundTasks.removeValue(forKey: uuid) else { return }
        UIApplication.shared.endBackgroundTask(identifier)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let taskUUID = UUID()
        startBackgroundTask(with: taskUUID)
        let pollenStore = PollenStore()
        pollenStore.refresh { [weak self] result in
            switch result {
            case .value:
                NotificationCenter.default.post(name: Notification.PollenUpdatedFromRemoteNotification, object: nil)
                completionHandler(.newData)
            case .error:
                completionHandler(.failed)
            }
            self?.endBackgroundTask(with: taskUUID)
        }
    }
    
    @available(iOS 10.0, *)
    func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions {
        return [ .alert, .sound, .badge ]
    }
}
