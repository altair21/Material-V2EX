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
    @IBOutlet weak var contentTextView: UITextView!
    
    // Data
    var data: TopicReplyModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale = UIScreen.main.scale
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.rasterizationScale = scale
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = scale
        avatarView.layer.shouldRasterize = true
        avatarView.layer.rasterizationScale = scale
        nameLabel.layer.shouldRasterize = true
        nameLabel.layer.rasterizationScale = scale
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scale
        thanksLabel.layer.shouldRasterize = true
        thanksLabel.layer.rasterizationScale = scale
    }
    
    func setData(data: TopicReplyModel) {
        self.data = data
        
        avatarView.setImageWith(url: (data.author.avatarURL))
        nameLabel.text = data.author.username
        dateLabel.text = data.date
        thanksLabel.text = data.thanks
        
        if data.renderContent != nil {
            contentTextView.attributedText = data.renderContent
        } else {
            data.renderContent = NSMutableAttributedString.contentFromHTMLString(data.content, fontName: contentTextView.font!.fontName, widthConstraint: Global.Constants.screenWidth - Global.Config.renderContentMargin)
            contentTextView.attributedText = data.renderContent
        }
    }

}
