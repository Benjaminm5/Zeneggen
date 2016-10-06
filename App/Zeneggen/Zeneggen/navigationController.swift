//
//  navigationController.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 01.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class navigationController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //bar items color
        self.view.tintColor = secondaryBlackOnWhiteBackground
        
        //bar background color
        self.navigationBar.barTintColor = mainColor
        
        //bar title color
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: blackOnWhiteBackground]
        
    }

}
