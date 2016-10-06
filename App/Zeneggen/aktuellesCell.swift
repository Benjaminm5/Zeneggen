//
//  aktuellesCell.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 15.06.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class aktuellesCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textsLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    
    var authorKey = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = blackOnWhiteBackground
        dateLabel.textColor = secondaryBlackOnWhiteBackground
        textsLabel.textColor = blackOnWhiteBackground
        authorButton.tintColor = secondaryColor
        
    }
    
}
