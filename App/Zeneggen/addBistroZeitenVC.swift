//
//  addBistroZeitenVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 06.07.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase

class addBistroZeitenVC: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    //Segment
    @IBOutlet weak var segmentDayOfWeek: UISegmentedControl!
    //Label
    @IBOutlet weak var errorLabel: UILabel!
    //Textfield
    @IBOutlet weak var morgenAufTextfield: UITextField!
    @IBOutlet weak var morgenZuTextfield: UITextField!
    @IBOutlet weak var nachmittagAufTextfield: UITextField!
    @IBOutlet weak var nachmittagZuTextfield: UITextField!
    @IBOutlet weak var abendAufTextfield: UITextField!
    @IBOutlet weak var abendZuTextfield: UITextField!
    //Button
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func postButton(_ sender: AnyObject) {
        
        if !(segmentDayOfWeek.selectedSegmentIndex < 0) {
            
            errorLabel.alpha = 0
            
            let day = (segmentDayOfWeek.selectedSegmentIndex + 1)
            
            
            let post = ["a-morgen-auf": NSNumber(value: Double(morgenAufTextfield.text!)! as Double),
                        "a-morgen-zu": NSNumber(value: Double(morgenZuTextfield.text!)! as Double),
                        "b-nachmittag-auf": NSNumber(value: Double(nachmittagAufTextfield.text!)! as Double),
                        "b-nachmittag-zu": NSNumber(value: Double(nachmittagZuTextfield.text!)! as Double),
                        "c-abend-auf": NSNumber(value: Double(abendAufTextfield.text!)! as Double),
                        "c-abend-zu": NSNumber(value: Double(abendZuTextfield.text!)! as Double)]
             let childUpdates = ["/categories/Bistro/de/\(day)": post]
            
            ref.updateChildValues(childUpdates)
            
        } else {
            
            errorLabel.text = "No day selected!"
            errorLabel.textColor = UIColor.red
            errorLabel.alpha = 1
            
        }
        
    }
    
    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        
        segmentDayOfWeek.selectedSegmentIndex = -1
        
        errorLabel.alpha = 0
        
    }

}
