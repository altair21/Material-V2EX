//
//  MemberTopicTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class MemberTopicTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nodeLabel: PaddingLabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    
    var data: MemberTopicModel? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale = UIScreen.main.scale
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.rasterizationScale = scale
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scale
        nodeLabel.layer.shouldRasterize = true
        nodeLabel.layer.rasterizationScale = scale
        replyCountLabel.layer.shouldRasterize = true
        replyCountLabel.layer.rasterizationScale = scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: MemberTopicModel) {
        self.data = data
    
        titleLabel.text = data.title
        dateLabel.text = data.lastModifyText
        nodeLabel.text = data.nodeTitle
        replyCountLabel.text = "\(data.replies)"
    }
    
}
