//
//  TopicOverviewTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let scaleValue = UIScreen.main.scale

class TopicOverviewTableViewCell: UITableViewCell {
    // UI
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = scaleValue
        bgView.layer.shadowRadius = 4
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.cornerRadius = 2
        return bgView
    }()
    
    lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.font = UIFont(name: "PingFangSC-Regular", size: 14.0)
        nicknameLabel.textColor = UIColor.black
        nicknameLabel.layer.shouldRasterize = true
        nicknameLabel.layer.rasterizationScale = scaleValue
        return nicknameLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateLabel.textColor = UIColor.fromHex(string: "#AAAAAA")
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scaleValue
        return dateLabel
    }()
    
    lazy var nodeLabel: PaddingLabel = {
        let nodeLabel = PaddingLabel()
        nodeLabel.backgroundColor = UIColor.fromHex(string: "#E2E2E2")
        nodeLabel.textColor = UIColor.fromHex(string: "#777777")
        nodeLabel.font = UIFont(name: "PingFangSC-Regular", size: 12.0)
        nodeLabel.layer.shouldRasterize = true
        nodeLabel.layer.rasterizationScale = scaleValue
        nodeLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh + 1, for: .horizontal)
        return nodeLabel
    }()
    
    lazy var repliesLabel: UILabel = {
        let repliesLabel = UILabel()
        repliesLabel.backgroundColor = UIColor.fromHex(string: "#969CB1")
        repliesLabel.textColor = UIColor.white
        repliesLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        repliesLabel.textAlignment = .center
        repliesLabel.layer.shouldRasterize = true
        repliesLabel.layer.rasterizationScale = scaleValue
        repliesLabel.layer.masksToBounds = true
        repliesLabel.layer.cornerRadius = 10
        return repliesLabel
    }()
    
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.layer.shouldRasterize = true
        avatarView.layer.rasterizationScale = scaleValue
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 3.33
        avatarView.contentMode = .scaleToFill
        avatarView.isUserInteractionEnabled = true
        return avatarView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 16.0)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.preferredMaxLayoutWidth = 100
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.rasterizationScale = scaleValue
        return titleLabel
    }()
    
    // Data
    var data: TopicOverviewModel? = nil
    var indexPath: IndexPath? = nil
    
    enum TopicReadState {
        case read
        case unread
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scaleValue
        self.contentView.layer.shouldRasterize = true
        self.contentView.layer.rasterizationScale = scaleValue
        contentView.backgroundColor = UIColor.fromHex(string: "#EFEFF4")
        contentView.addSubview(bgView)
        contentView.addSubview(avatarView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(nodeLabel)
        contentView.addSubview(repliesLabel)
        contentView.addSubview(titleLabel)
        
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarTapped(sender:)))
        avatarView.addGestureRecognizer(tapAvatar)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConstraints() {
        bgView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(6, 8, 6, 8))
        }
        avatarView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(bgView).offset(8)
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(bgView).offset(8)
        }
        nicknameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.top.equalTo(bgView).offset(8)
            make.right.greaterThanOrEqualTo(nodeLabel.snp.left).offset(-10)
            make.height.equalTo(17)
        }
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalTo(bgView).offset(-10)
        }
        nodeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bgView).offset(8)
            make.right.equalTo(repliesLabel.snp.left).offset(-8)
            make.height.equalTo(20)
        }
        repliesLabel.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 38, height: 20))
            make.top.equalTo(bgView).offset(8)
            make.right.equalTo(bgView).offset(-10)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.left.equalTo(bgView).offset(10)
            make.right.equalTo(bgView).offset(-10)
            make.bottom.equalTo(bgView).offset(-8)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight: CGFloat = 40
        totalHeight += 40
        totalHeight += titleLabel.sizeThatFits(size).height
        return CGSize(width: size.width, height: totalHeight)
    }
    
    func setData(data: TopicOverviewModel, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
        
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
    
    func avatarTapped(sender: UITapGestureRecognizer) {
        if let data = data, let indexPath = indexPath {
            NotificationCenter.default.post(name: Global.Notifications.kOpenMemberFromHome,
                                            object: nil,
                                            userInfo: ["data": data.author, "indexPath": indexPath])
        }
    }

}
