//
//  MemberReplyTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class MemberReplyTableViewCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var data: MemberReplyModel? = nil
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale
        infoLabel.layer.shouldRasterize = true
        infoLabel.layer.rasterizationScale = scale
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scale
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.rasterizationScale = scale
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.rasterizationScale = scale
        
        let tapTitle = UITapGestureRecognizer(target: self, action: #selector(titleTapped(sender:)))
        titleLabel.addGestureRecognizer(tapTitle)
    }
    
    @objc func titleTapped(sender: UITapGestureRecognizer) {
        if let data = data, let indexPath = indexPath {
            let memberViewController = viewController(ofView: self) as! MemberViewController
            memberViewController.openTopic(url: data.href, title: data.topicTitle, indexPath: indexPath)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: MemberReplyModel, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
        
        infoLabel.text = data.replyInfo
        dateLabel.text = data.date
        titleLabel.text = data.topicTitle
        
        if data.renderContent != nil {
            contentTextView.attributedText = data.renderContent
        } else {
            data.renderContent = NSMutableAttributedString.contentFromHTMLString(data.content, fontName: contentTextView.font!.fontName, widthConstraint: Global.Constants.screenWidth - Global.Config.renderContentMargin)
            contentTextView.attributedText = data.renderContent
        }
    }

}
