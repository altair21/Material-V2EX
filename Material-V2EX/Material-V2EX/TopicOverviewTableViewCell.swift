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
    
    enum TopicReadState {
        case read
        case unread
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setData(data: TopicOverviewModel) {
        self.data = data
        
        nicknameLabel.text = data.author.username
        dateLabel.text = (data.last_modifiedText.characters.count > 0) ? data.last_modifiedText : Date(timeIntervalSince1970: data.last_modified).timeAgo
        if let node = data.node {
            nodeLabel.text = node.name
            nodeLabel.isHidden = false
        } else {
            nodeLabel.isHidden = true
        }
        repliesLabel.text = "\(data.replies)"
        avatarView.setImageWith(url: (data.author.avatarURL))
        titleLabel.text = data.title
        
        animatedUI()
    }
    
    func animatedUI() {
        configureReadState(state: (data?.markRead)! ? .read : .unread)
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
    
    func configureReadState(state: TopicReadState) {
        let animateDuration = 0.3
        switch state {
        case .read:
            bgView.layer.shadowRadius = 3.25
            let shadowAnim = CABasicAnimation(keyPath: "layer.shadowRadius")
            shadowAnim.fillMode = kCAFillModeBoth
            shadowAnim.fromValue = 0.75
            shadowAnim.toValue = 3.25
            shadowAnim.duration = animateDuration
            UIView.animate(withDuration: animateDuration, animations: {
                self.repliesLabel.backgroundColor = UIColor.fromHex(string: "#E5E5E5")
            })
        case .unread:
            bgView.layer.shadowRadius = 0.75
            repliesLabel.backgroundColor = UIColor.fromHex(string: "#969CB1")
        }
    }

}
