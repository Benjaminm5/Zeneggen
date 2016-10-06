//
//  webVC.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 08.04.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class webVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var URLPath = "http://google.ch"
    
    func loadAddressURL() {
        
        let requestURL = NSURL(string: URLPath)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
        
    }
    
    override func viewDidLoad() {
        
        loadAddressURL()
        
    }

}
