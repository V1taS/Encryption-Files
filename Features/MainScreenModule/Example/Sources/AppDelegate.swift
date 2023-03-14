//
//  AppDelegate.swift
//  MainScreenModuleExample
//
//  Created by Sosin_Vitalii on 15/03/2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
  var window: UIWindow?
  private let appController = AppController()
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = MainScreenModuleViewController()
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
