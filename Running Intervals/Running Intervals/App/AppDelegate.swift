//
//  AppDelegate.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 24/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MediaPlayer

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = MusicRepository.shared
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setRootViewController(viewController: UIViewController, animated: Bool) {
        
        
        if let scene = UIApplication.shared.connectedScenes.first{
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window: UIWindow = UIWindow(windowScene: windowScene)
            window.windowScene = windowScene //Make sure to do this
            window.rootViewController = nil
            window.rootViewController = viewController
            appDelegate.window?.rootViewController = nil
            appDelegate.window = window
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
}

