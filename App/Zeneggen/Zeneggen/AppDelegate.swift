//
//  AppDelegate.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 08.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        //let splitViewController = self.window!.rootViewController as! UISplitViewController
        //let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        //navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        //splitViewController.delegate = self
        
        if #available(iOS 10.0, *) {
            
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            UIApplication.shared.registerForRemoteNotifications()
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = AppDelegate()
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = AppDelegate()
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        setupRootViewController(false)
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        /*
        //set
        let navigationBarColor = UIColor(red: 73/255, green: 191/255, blue: 17/255, alpha: 1.0)
        NSUserDefaults.standardUserDefaults().setValue(navigationBarColor as UIColor, forKey: "navigationBarColor")
        //get
        //let navigationBarColor = NSUserDefaults.standardUserDefaults().stringForKey("navigationBarColor")
        */
        return true
    }
    
    func setupRootViewController(_ animated: Bool) {
        if let window = self.window {
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            
            // create and setup appropriate rootViewController
            if !launchedBefore {
                print("First launch, setting NSUserDefault.")
                let welcomeViewController = window.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "welcomeVC") as! notificationsWelcomeView
                newRootViewController = welcomeViewController
                transition = .transitionCrossDissolve
                
            } else {
                print("Not first launch.")
                
                // Add observer for InstanceID token refresh callback.
                NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
                
                let splitViewController = window.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "SplitVC") as! UISplitViewController
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
                navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
                splitViewController.delegate = self
                splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
                
                let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
                let controller = masterNavigationController.topViewController as! MasterViewController
                
                print(controller)
                newRootViewController = splitViewController
                transition = .transitionCurlUp
            }
                
            // update app's rootViewController
            if let rootVC = newRootViewController {
                if animated {
                    UIView.transition(with: window, duration: 0.5, options: transition, animations: { () -> Void in
                        window.rootViewController = rootVC
                        }, completion: nil)
                } else {
                    window.rootViewController = rootVC
                }
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Let FCM know about the message for analytics etc.
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        
        let alert = (userInfo["aps" as NSObject]!) as! [String: AnyObject]
        // let alert = userInfo["aps"]!
        print("BEN: \(alert["alert"])")
        
        displayErrorAlert("Zeneggen App", error: "\(alert["alert"])")
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id" as NSObject]!)")
        
        // Print full message.
        print("%@", userInfo)
        
    }
    
    func displayErrorAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = secondaryColor
        
        alert.addAction(UIAlertAction(title: "Mehr", style: .default, handler: { action in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            print("I want to show the alert!")
            
        }))
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { action in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            print("I want to close the alert!")
            
        }))
        
        //self.presentViewController(alert, animated: true, completion: nil)
        //print("I want to show the alert!")
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)

        //self.root
        
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func userDidIndicateTheyWouldAllowNotifications() {
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        connectToFcm()
        print("Reconnected to FCM.")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFcm()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.viewCategory == "" {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    //Setup Root View Controller from anywhere
    func changeRootViewControllerWithIdentifier(identifier:String!) {
        let storyboard = self.window?.rootViewController?.storyboard
        let desiredViewController = storyboard?.instantiateViewController(withIdentifier: identifier);
        
        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        desiredViewController?.view.addSubview(snapshot);
        
        self.window?.rootViewController = desiredViewController;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview();
        });
    }
    
    class func sharedAppDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate;
    }
    
    func registerForPushNotifications() {
        /*
        if #available(iOS 10.0, *) {
            
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            UIApplication.shared.registerForRemoteNotifications()
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        */
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    private func userNotificationCenter(center: UNUserNotificationCenter,
                                willPresentNotification notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}
// [END ios_10_message_handling

