//
//  AppDelegate.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 26.05.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds) //граница экрана
        window?.makeKeyAndVisible() //сделать окно ключевым и видимым, по сути это главный экран
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController()) //назначение стартого вьюконтроллера, с которым мы будем работать, с помощью rootViewController можем присвоить текущий вьюконтроллер, который у нас есть по умолчанию
        
        return true
    }
}

