//
//  activityIndicatorV.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 26.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class activityIndicatorV: UIActivityIndicatorView {
    
    var removing = false
    
    let backgroundView: UIView = UIView()
    
    override func didMoveToSuperview() {
        
        //
 
    }
    
    override func layoutSubviews() {
        
        if removing == false {
            
            let viewCenter = (CGPoint(x: (superview?.center.x)!, y: (superview?.center.y)! - 33))
            //print(superview?.center)
            
            //Background
            backgroundView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            backgroundView.center = viewCenter
            backgroundView.backgroundColor = UIColor.lightGray
            backgroundView.alpha = 0.5
            backgroundView.layer.cornerRadius = backgroundView.frame.height/2
            self.superview?.addSubview(backgroundView)
            
            self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.center = viewCenter
            self.hidesWhenStopped = true
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            self.startAnimating()
            self.removing = true
            
        }
        
    }
    
    func removeViews() {
        
        self.removeFromSuperview()
        backgroundView.removeFromSuperview()
        
    }
    
}
