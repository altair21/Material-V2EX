//
//  AllNodesCollectionViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import CoreText

class AllNodesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        nameLabel.layer.shouldRasterize = true
        nameLabel.layer.rasterizationScale = UIScreen.main.scale
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1.0
//        self.layer.cornerRadius = 20
        nameLabel.backgroundColor = UIColor.white
    }
    
    func setData(name: String, width: CGFloat) {
        nameLabel.text = name
        
        DispatchQueue.main.async {
            self.nameLabel.frame = CGRect(x: 0, y: 0, width: width + Global.Config.unitNodeCellPadding + Global.Config.unitNodeCellPadding, height: Global.Config.unitNodeCellHeight)
            self.nameLabel.isHidden = false
        }
    }
}
