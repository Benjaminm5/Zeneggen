//
//  LaunchVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 30.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var launchLabel: UILabel!
    @IBOutlet weak var versionDetailsLabel: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    
    let titleLabelText = "Zeneggen"
    let launchLabelText = "\"Es Paradiis, wies niene git.\""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleLabelText
        launchLabel.text = launchLabelText
        versionDetailsLabel.text = "Version \(self.appVersion()) (\(self.buildVersion())"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
    }
    
    func buildVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
    }

}
