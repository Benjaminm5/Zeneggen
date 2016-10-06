//
//  genderVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 14.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class genderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func femaleButton(_ sender: AnyObject) {
        
        FIRAnalytics.setUserPropertyString("male", forName: "Geschlecht_manually")
        
        goBackToSplitVC()
        
    }
    
    @IBAction func maleButton(_ sender: AnyObject) {
        
        FIRAnalytics.setUserPropertyString("female", forName: "Geschlecht_manually")
        
        goBackToSplitVC()
        
    }
    
    @IBAction func nopeButton(_ sender: AnyObject) {
        
        goBackToSplitVC()
        
    }
    
    func goBackToSplitVC() {
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        //delegate.setupRootViewController(false)
        
        //let appDelegate = AppDelegate.sharedAppDelegate()
        //appDelegate?.changeRootViewControllerWithIdentifier(identifier: "multimediaNav")
        
        let appDelegate = AppDelegate.sharedAppDelegate()
        appDelegate?.setupRootViewController(false)
        
    }

}
