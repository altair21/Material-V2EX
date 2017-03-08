//
//  MemberTopicTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class MemberTopicTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nodeLabel: PaddingLabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    
    var data: MemberTopicModel? = nil
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.rasterizationScale = scale
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scale
        nodeLabel.layer.shouldRasterize = true
        nodeLabel.layer.rasterizationScale = scale
        replyCountLabel.layer.shouldRasterize = true
        replyCountLabel.layer.rasterizationScale = scale
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(beTapped(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    func beTapped(sender: UITapGestureRecognizer) {
        if let data = data, let indexPath = indexPath {
            let memberViewController = viewController(ofView: self) as! MemberViewController
            memberViewController.openTopic(url: data.href, title: data.title, indexPath: indexPath)
        }
    }
    
    func setData(data: MemberTopicModel, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
    
        titleLabel.text = data.title
        dateLabel.text = data.lastModifyText
        nodeLabel.text = data.nodeTitle
        replyCountLabel.text = "\(data.replies)"
    }
    
}
