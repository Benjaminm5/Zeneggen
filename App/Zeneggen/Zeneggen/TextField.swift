//
//  TextField.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 24.08.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = secondaryBlackOnWhiteBackground.cgColor
        self.textColor = blackOnWhiteBackground
        self.tintColor = secondaryColor
        
    }
    
    //Placeholder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 5)
    }
    
    //Editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 5)
    }

}
