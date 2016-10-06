//
//  detailTableCell.swift
//  Zeneggen
//
//  Created by Benjamin Pfammatter on 01.09.16.
//  Copyright © 2016 Benjamin Pfammatter. All rights reserved.
//

import UIKit

class personDetailTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = blackOnWhiteBackground
        detailLabel.textColor = secondaryBlackOnWhiteBackground
        photoImageView.backgroundColor = secondaryBlackOnWhiteBackground
        photoImageView.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.height / 2
        
    }
    
}