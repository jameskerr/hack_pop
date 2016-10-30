//
//  AppDelegate.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/14/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK
import Bugsnag

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        CookieStore.loadCookies()
        registerForPushNotifications(application: application)
        let flurryApiKey = KeyFetcher.getApiKey(key: "Flurry Api Key") as! String?
        if let flurryApiKey = flurryApiKey {
            Flurry.startSession(flurryApiKey)
            Flurry.setCrashReportingEnabled(true)
            Flurry.setEventLoggingEnabled(true)
        }
        let bugSnagApiKey = KeyFetcher.getApiKey(key: "BugSnag Api Key") as! String?
        if let bugSnagApiKey = bugSnagApiKey {
            Bugsnag.start(withApiKey: bugSnagApiKey)
            #if DEBUG
                Bugsnag.configuration()?.releaseStage = "develop"
            #else
                Bugsnag.configuration()?.releaseStage = "production"
            #endif
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CookieStore.saveCookies()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        CookieStore.loadCookies()
        registerForPushNotifications(application: application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        CookieStore.loadCookies()
        registerForPushNotifications(application: application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        CookieStore.saveCookies()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hack_pop" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "hack_pop", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //
        let story = Story.storyFromPush(pushData: userInfo)
        story.isUnreadStory = true
        Story.current = story
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = webViewController
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        Flurry.setUserID(token)
        if let oldToken = Client.instance().storedToken,
            oldToken == token {
            let client =  Client.instance()
            client.token = token
            client.successfullySetId = true
        } else {
           HackPopServer.setClient(id: token, delegate: self)
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        showFailedAlert(title:"Cannot Set Notifications", message:"Hacker News Alerts will not be able to set a point threshold for you or send you notifications unless you enable notifications for Hacker News Alerts.")
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func showFailedAlert(title:String, message:String) {
        let alert = HackPopStyle.CreateAlertMessage(title: title, message: message)
        if let viewController = self.window?.rootViewController {
            AppDelegate.delay(delay: 0.4) {
                viewController.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) { closure() }
    }
}

extension AppDelegate: HttpClientCreateListener {
    
    func onClientCreated(id:String) {
        Client.instance().storedToken = id
    }
    
    func onClientCreatedFailed(error: Error) {
        Client.instance().successfullySetId = false
        showFailedAlert(title:"Failed To Connect To Server", message:"If you are offline, please try restarting Hacker News Alerts when you have an internet connection.")
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

