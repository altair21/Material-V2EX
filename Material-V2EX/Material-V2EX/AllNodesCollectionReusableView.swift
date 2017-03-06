//
//  AllNodesCollectionReusableView.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/4.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class AllNodesCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
    
}
