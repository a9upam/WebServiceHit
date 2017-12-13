//
//  AppDelegate.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam G on 12/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability : Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0
    var networkStatus : UILabel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        networkStatus = UILabel(frame: CGRect(x: 0, y: 0, width: (window?.frame.size.width)!, height: 50))
        window?.addSubview(networkStatus)
        startHost(at: 0)
        let userListViewController = UserListViewController(nibName: "UserListViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: userListViewController)
        navController.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = navController
        return true
    }

    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 3)
        }
    }
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
//            hostNameLabel?.text = hostName
        } else {
            reachability = Reachability()
//            hostNameLabel.text = "No host name"
        }
        self.reachability = reachability
//        print("--- set up with host name: \(hostNameLabel.text!)")
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateLabelColourWhenNotReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            networkStatus.textColor = .red
            networkStatus.text = "Unable to start\nnotifier"
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        if reachability.connection == .wifi {
            self.networkStatus.textColor = .green
        } else {
            self.networkStatus.textColor = .blue
        }
        
        self.networkStatus.text = "\(reachability.connection)"
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        
        self.networkStatus.textColor = .red
        
        self.networkStatus.text = "\(reachability.connection)"
    }
    
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
    
    deinit {
        stopNotifier()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NetworkAndCoreDataTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

