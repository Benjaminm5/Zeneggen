//
//  webStandardVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 17.08.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class webStandardVC: UIViewController {
    
    var viewCategory = ""
    var urlReceived = URL(string: "")
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        print(urlReceived)
        
        self.navigationItem.title = viewCategory
        
        let requestObj = URLRequest(url: urlReceived!)
        webView.loadRequest(requestObj)
        
    }

}
