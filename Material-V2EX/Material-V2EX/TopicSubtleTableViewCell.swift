//
//  TopicSubtleTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/22.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class TopicSubtleTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: TopicSubtleModel) {
        dateLabel.text = data.date
        
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
