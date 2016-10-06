//
//  notificationsWelcomeView.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 09.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
//import FirebaseInstanceID
import UserNotifications

class notificationsWelcomeView: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    var viewCategory = ""
    
    //set up activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var nopeButton: UIButton!
    @IBOutlet weak var imageText1Label: UILabel!
    @IBOutlet weak var imageText2Label: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var imageMiddle: UIImageView!
    
    // MARK: - Button actions
    
    @IBAction func acceptButton(_ sender: AnyObject) {
        
        userDidIndicateTheyWouldAllowNotifications()
        
    }
    
    @IBAction func nopeButton(_ sender: AnyObject) {
        
        goBackToSplitVC()
        
    }
    
    func userDidIndicateTheyWouldAllowNotifications() {
        
        
        
        //let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        //let settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        //UIApplication.shared.registerUserNotificationSettings(settings)
        //UIApplication.shared.registerForRemoteNotifications()
        
        goBackToSplitVC()
        
        
        
    }
    
    func goBackToSplitVC() {
        /*
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setupRootViewController(true)
        */
        
        performSegue(withIdentifier: "goToGenderUI", sender: self)
        
    }
    
    override func viewDidLoad() {
        
        hideAllOutlets()
        
        //activity indicator has to start now!
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //ignore taps on screen
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        viewCategory = "notificationsWelcome"
        
        ref = FIRDatabase.database().reference()
        
        if viewCategory != "" {
            
            ref.child("categories").child(viewCategory).child("de").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                // Get user value
                
                let data = snapshot.value as! [String : AnyObject]
                
                let title = data["title"] as! String
                let text = data["text"] as! String
                let acceptButton = data["acceptButton"] as! String
                let nopeButton = data["nopeButton"] as! String
                let imageText1 = data["imageText1"] as! String
                let imageText2 = data["imageText2"] as! String
                /*
                let title = snapshot.value!["title"] as! String
                let text = snapshot.value!["text"] as! String
                let acceptButton = snapshot.value!["acceptButton"] as! String
                let nopeButton = snapshot.value!["nopeButton"] as! String
                let imageText1 = snapshot.value!["imageText1"] as! String
                let imageText2 = snapshot.value!["imageText2"] as! String
                */
                self.titleLabel.text = title
                self.textLabel.text = text
                self.acceptButton.setTitle(acceptButton, for: UIControlState())
                self.nopeButton.setTitle(nopeButton, for: UIControlState())
                self.imageText1Label.text = imageText1
                self.imageText2Label.text = imageText2
                
                //Stop activity indicator
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                self.showAllOutlets()
                
            }) { (error) in
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    
    
    func showAllOutlets() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.imageMiddle.alpha = 1
            
            }, completion: {
                
                (value: Bool) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.titleLabel.alpha = 1
                    self.textLabel.alpha = 1
                    self.acceptButton.alpha = 1
                    self.nopeButton.alpha = 1
                    self.imageText1Label.alpha = 1
                    self.imageText2Label.alpha = 1
                    self.image1.alpha = 1
                    self.image2.alpha = 1
                    
                })
            
            })
        
    }
    
    func hideAllOutlets() {
        
        self.titleLabel.alpha = 0
        self.textLabel.alpha = 0
        self.acceptButton.alpha = 0
        self.nopeButton.alpha = 0
        self.imageText1Label.alpha = 0
        self.imageText2Label.alpha = 0
        self.image1.alpha = 0
        self.image2.alpha = 0
        self.imageMiddle.alpha = 0
        
    }

}
/*
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
*/
