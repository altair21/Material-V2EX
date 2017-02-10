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
    @IBOutlet weak var contentTextView: UITextView!
    
    // Data
    var data: TopicOverviewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(overview overviewData: TopicOverviewModel, data: TopicModel) {
        self.data = overviewData
        
        nameLabel.text = overviewData.author.username
        avatarView.setImageWith(url: (overviewData.author.avatarURL))
        dateLabel.text = data.dateAndClickCount
        nodeLabel.text = overviewData.node?.name
        
        if data.renderContent != nil {
            contentTextView.attributedText = data.renderContent
        } else {
            data.renderContent = NSMutableAttributedString.contentFromHTMLString(data.content, fontName: contentTextView.font!.fontName, widthConstraint: Global.Constants.screenWidth - Global.Config.renderContentMargin)
            contentTextView.attributedText = data.renderContent
        }
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.rasterizationScale = UIScreen.main.scale
    }

}
