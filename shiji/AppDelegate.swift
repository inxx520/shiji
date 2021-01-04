//
//  AppDelegate.swift
// shiji
//
//  Created by 小仙女 on 20/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 216.0/255, green: 74.0/255, blue: 32.0/255, alpha: 1.0)
        
     
        UINavigationBar.appearance().tintColor = UIColor.white
        
   
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: barFont]
        }
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
 
        UITabBar.appearance().tintColor = UIColor(red: 235.0/255, green: 75.0/255, blue: 27.0/255, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor(red: 236.0/255, green: 240.0/255, blue: 241.0/255, alpha: 1.0)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
     
    }

    

    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "shiji")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    
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

