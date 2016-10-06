//
//  DetailViewController.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 08.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit
import Firebase
class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var ref: FIRDatabaseReference!
    
    //var viewCategory = ""
    
    var number = 0
    
    var viewCategory: String = "" {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        //viewCategory = "home"
        
        ref = FIRDatabase.database().reference()
        
        detailDescriptionLabel.text = viewCategory
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

