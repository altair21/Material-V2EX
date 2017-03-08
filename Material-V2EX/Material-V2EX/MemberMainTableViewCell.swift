//
//  MemberMainTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class MemberMainTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinNumberLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale
        avatarView.layer.shouldRasterize = true
        avatarView.layer.rasterizationScale = scale
        nameLabel.layer.shouldRasterize = true
        nameLabel.layer.rasterizationScale = scale
        joinNumberLabel.layer.shouldRasterize = true
        joinNumberLabel.layer.rasterizationScale = scale
        joinDateLabel.layer.shouldRasterize = true
        joinDateLabel.layer.rasterizationScale = scale
    }

    func setAvatarUrl(_ url: String, name: String, joinNumber joinNumberStr: String, joinDate joinDateStr: String) {
        avatarView.setImageWith(url: url)
        nameLabel.text = name
        joinNumberLabel.text = joinNumberStr
        joinDateLabel.text = joinDateStr
    }

}
