//
//  detailTableCell.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 01.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class detailTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = blackOnWhiteBackground
        detailLabel.textColor = secondaryBlackOnWhiteBackground
        
    }
    
}
