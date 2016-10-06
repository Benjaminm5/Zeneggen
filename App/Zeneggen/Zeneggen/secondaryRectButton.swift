//
//  secondaryRectButton.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 01.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class secondaryRectButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        self.backgroundColor = secondarySecondaryColorLight
        self.setTitleColor(secondaryBlackOnWhiteBackground, for: UIControlState())
        
    }

}
