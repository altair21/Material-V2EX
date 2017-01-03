//
//  TopicOverviewTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class TopicOverviewTableViewCell: UITableViewCell {
    // UI
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nodeLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Data
    var data: TopicOverviewModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setData(data: TopicOverviewModel) {
        self.data = data
        
        nicknameLabel.text = data.member?.username
        dateLabel.text = Date(timeIntervalSince1970: data.created).timeAgo
        nodeLabel.text = data.node?.title
        repliesLabel.text = "\(data.replies)"
        avatarView.setImageWith(string: (data.member?.avatarURL)!)
        titleLabel.text = data.title
        
        animatedUI()
    }
    
    func animatedUI() {
        if (data?.isAnimated)! {
            return
        }
        data?.isAnimated = true
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.fillMode = kCAFillModeBoth
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.beginTime = CACurrentMediaTime()
        bgView.layer.add(animation, forKey: nil)
        
    }

}
