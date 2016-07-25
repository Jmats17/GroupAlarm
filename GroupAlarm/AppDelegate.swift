     //
//  AppDelegate.swift
//  GroupAlarm
//
//  Created by Justin Matsnev on 7/14/15.
//  Copyright (c) 2015 Justin Matsnev. All rights reserved.
//

import UIKit
import Parse
import Bolts
     
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        Mixpanel.sharedInstanceWithToken("a37320af793c6e93fbf32e0b549b79cd")
        let defaults : NSUserDefaults = NSUserDefaults()
        var getStartedBool = true
        defaults.setObject(getStartedBool, forKey: "firstTime")
        defaults.synchronize()
        let appOpened : Int = Int()
        Parse.enableLocalDatastore()
        Parse.setApplicationId("13N3EMnXOVFVOVAGQB6vuax1u7dNqVX3PFj0us96",
            clientKey: "f7EqC7dH3rxXCLOYRSyvZX4JcKvrLboLXdc3uxTk")
                let currentUser = PFUser.currentUser()
                if currentUser != nil {
                    Mixpanel.sharedInstance().track("App Opened", properties: ["Existing User": appOpened])
                    
                    let currentInstallation = PFInstallation.currentInstallation()
                    
                    if currentInstallation["user"] == nil {
                        
                        currentInstallation["user"] = PFUser.currentUser()!
                        
                        currentInstallation.saveInBackgroundWithBlock { (didSave, error) -> Void in
                        }
                        
                    }
                    
                    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") 
        
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
                else {
                    let firstTime = defaults.objectForKey("firstTime") as! Bool
                    if firstTime == true {
                        Mixpanel.sharedInstance().track("App Opened", properties: ["New user": appOpened])
                        
                        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let initialViewController = storyboard.instantiateViewControllerWithIdentifier("onboarding") 
                        getStartedBool = false
                        defaults.setObject(getStartedBool, forKey: "firstTime")
                        defaults.synchronize()
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                    if firstTime == false {
                        Mixpanel.sharedInstance().track("App Opened", properties: ["New user": appOpened])
                        
                        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
<<<<<<< HEAD
                        var initialViewController = storyboard.instantiateViewControllerWithIdentifier("start") 
=======
                        let initialViewController = storyboard.instantiateViewControllerWithIdentifier("start") 
>>>>>>> 48ab17fd49076e4c768c2b50b4cf1d83df1bc764
                        
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                    
                }
      
        
        
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
        
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)

<<<<<<< HEAD
                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") 
=======
                let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") 
>>>>>>> 48ab17fd49076e4c768c2b50b4cf1d83df1bc764
               
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
<<<<<<< HEAD
        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            
            let types : UIRemoteNotificationType = [.Alert ,.Badge ,.Sound]
=======
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [UIRemoteNotificationType.Badge, UIRemoteNotificationType.Alert, UIRemoteNotificationType.Sound]
>>>>>>> 48ab17fd49076e4c768c2b50b4cf1d83df1bc764
            application.registerForRemoteNotificationTypes(types)
        }
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        var dateFormatter = NSDateFormatter()
        
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            if let timeDictionary = userInfo["time"] as? NSDictionary, objID = timeDictionary["objectId"] as? String {
//                println(userInfo)
//                println("obj id = \(objID)")

                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("GroupCurrentAlarm") as! GroupCurrentAlarmViewController
                initialViewController.groupObjId = objID
                initialViewController.cameFromAppDel = true
                Mixpanel.sharedInstance().trackPushNotification(["NotificationWentOff": userInfo])
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            } else {
                print("ERROR: should never get here")
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") as! GroupCurrentAlarmViewController
              
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        else if application.applicationState == UIApplicationState.Active {
            
            if let timeDictionary = userInfo["time"] as? NSDictionary, objID = timeDictionary["objectId"] as? String {
//                println(userInfo)
//                println("obj id = \(objID)")
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                var storyboard = UIStoryboard(name: "Main", bundle: nil)

                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("GroupCurrentAlarm") as! GroupCurrentAlarmViewController
                initialViewController.groupObjId = objID
                initialViewController.cameFromAppDel = true
                Mixpanel.sharedInstance().trackPushNotification(["NotificationWentOff": userInfo])

                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            } else {
                print("ERROR: should never get here")
                print("ERROR: should never get here")
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") as! GroupCurrentAlarmViewController
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        else if application.applicationState == UIApplicationState.Background {
            if let timeDictionary = userInfo["time"] as? NSDictionary, objID = timeDictionary["objectId"] as? String {
                //println(userInfo)
                //println("obj id = \(objID)")
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                var storyboard = UIStoryboard(name: "Main", bundle: nil)

                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("GroupCurrentAlarm") as! GroupCurrentAlarmViewController
                initialViewController.groupObjId = objID
                initialViewController.cameFromAppDel = true
                Mixpanel.sharedInstance().trackPushNotification(["NotificationWentOff": userInfo])

                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            } else {
                print("ERROR: should never get here")
                print("ERROR: should never get here")
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") as! GroupCurrentAlarmViewController
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
    }
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    }
}
