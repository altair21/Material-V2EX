//
//  AllNodesCollectionViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class AllNodesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelMaxWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.frame.size.height / 2
        nameLabelMaxWidthConstraint.constant = Global.Constants.screenWidth - 32
    }
    
    func setData(name: String) {
        nameLabel.text = name
    }

}
