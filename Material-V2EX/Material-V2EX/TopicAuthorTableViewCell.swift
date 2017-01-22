//
//  TopicAuthorTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class TopicAuthorTableViewCell: UITableViewCell {
    // UI
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nodeLabel: PaddingLabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // Data
    var data: TopicOverviewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(overview data: TopicOverviewModel, content: String, date: String) {
        self.data = data
        
        nameLabel.text = data.author.username
        avatarView.setImageWith(string: (data.author.avatarURL))
        dateLabel.text = date
        nodeLabel.text = data.nodeTitle
        contentLabel.text = content
    }

}
