//
//  AppDelegate.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfiguration = UISceneConfiguration(name: "Default Configuration",
                                                  sessionRole: connectingSceneSession.role)
    sceneConfiguration.delegateClass = SceneDelegate.self
    return sceneConfiguration
  }
}
