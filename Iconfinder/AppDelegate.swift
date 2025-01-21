// AppDelegate.swift
// Iconfinder
// Created by Dobrovsky on 20.11.2024.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let alphaModule = AlphaModuleFactory().make()
        let nav = CustomNavigationController(rootViewController: alphaModule)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}
