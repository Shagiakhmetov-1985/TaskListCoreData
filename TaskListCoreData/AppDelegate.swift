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
        window = UIWindow(frame: UIScreen.main.bounds)//граница экрана
        window?.makeKeyAndVisible()//сделать окно ключевым и видимым, по сути это главный экран
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())//назначение стартого вьюконтроллера, с которым мы будем работать, с помощью rootViewController можем присвоить текущий вьюконтроллер, который у нас есть по умолчанию
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext() //в случае приложение будет выгружено из памяти, то произойдет вызов метода saveContext() и все, что было изменено в контексте будет сохранено в постоянном хранилище. именно поэтому когда у вас там упадет xcode, когда мы с вами работали и завершили работу, запускаем его снова и все данные, которые там были внесены и они у вас сохраняются. именно поэтому, в операционных системах на маках нет кнопки сохранить
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

