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
    @IBOutlet weak var editTimeLabel: UILabel!
    
    // Data
    var data: TopicOverviewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data: TopicOverviewModel) {
        self.data = data
        
        nameLabel.text = data.author.username
        avatarView.setImageWith(string: (data.author.avatarURL))
        dateLabel.text = Date(timeIntervalSince1970: data.created).timeAgo
        nodeLabel.text = data.nodeTitle
        contentLabel.text = "马上做"
        editTimeLabel.text = "\(Date(timeIntervalSince1970: data.last_modified))    \(data.replies)条回复"
    }

}
