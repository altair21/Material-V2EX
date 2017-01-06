//
//  TopicReplyTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import Material

class TopicReplyTableViewCell: UITableViewCell {
    // UI
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var thanksImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    // Data
    var data: TopicReplyModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        thanksImageView.image = Icon.favorite
    }
    
    func setData(data: TopicReplyModel) {
        self.data = data
        
        avatarView.setImageWith(string: (data.member?.avatarURL)!)
        nameLabel.text = data.member?.username
        dateLabel.text = Date(timeIntervalSince1970: data.created).timeAgo
        contentLabel.text = data.content
        thanksLabel.text = "\(data.thanks)"
        thanksLabel.isHidden = data.thanks == 0
        thanksImageView.isHidden = data.thanks == 0
    }

}
