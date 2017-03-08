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
    var data: TopicModel?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale = UIScreen.main.scale
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = scale
        nameLabel.layer.shouldRasterize = true
        nameLabel.layer.rasterizationScale = scale
        avatarView.layer.shouldRasterize = true
        avatarView.layer.rasterizationScale = scale
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scale
        nodeLabel.layer.shouldRasterize = true
        nodeLabel.layer.rasterizationScale = scale
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.rasterizationScale = scale
        
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarTapped(sender:)))
        avatarView.addGestureRecognizer(tapAvatar)
    }
    
    func avatarTapped(sender: UITapGestureRecognizer) {
        if let data = data, let indexPath = indexPath {
            let topicViewController = viewController(ofView: self) as! TopicDetailViewController
            topicViewController.openMember(data: data.author, indexPath: indexPath)
        }
    }
    
    func setData(data: TopicModel, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
        
        nameLabel.text = data.author.username
        avatarView.setImageWith(url: (data.author.avatarURL))
        dateLabel.text = data.dateAndClickCount
        nodeLabel.text = data.nodeTitle
        
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
