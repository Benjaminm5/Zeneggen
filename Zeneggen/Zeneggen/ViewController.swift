//
//  ViewController.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 04.04.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var ref = Firebase(url: "zeneggen.firebaseio.com/admin/bepfam")
    
    //set up activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //activity indicator has to start now!
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //ignore taps on screen
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            self.nameLabel.text = "\(snapshot.value.objectForKey("surname")!)" + " " + "\(snapshot.value.objectForKey("name")!)"
            self.nicknameLabel.text = snapshot.value.objectForKey("nickname") as? String
            self.ageLabel.text = "Age: " + "\(snapshot.value.objectForKey("age") as! Int)"
            self.descriptionLabel.text = snapshot.value.objectForKey("description") as? String
            
            print((snapshot.value.objectForKey("imageLink") as? String)!)
            
            let imageUrl = NSURL(string: (snapshot.value.objectForKey("imageLink") as? String)!)
            let imageData = NSData(contentsOfURL: imageUrl!)
            if imageData != nil {
                
                self.profileImage.image = UIImage(data: imageData!)
                
            } else {
                
                print("imageError!")
                
            }
            
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}

