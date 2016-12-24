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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: TopicOverviewModel) {
        self.data = data
        
        nicknameLabel.text = data.member?.username
//        dateLabel
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
        
        let origX = bgView.frame.origin.x
        bgView.frame.origin.x = Global.screenWidth + 10
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [], animations: {
            self.bgView.frame.origin.x = origX
        }, completion: nil)
    }

}
