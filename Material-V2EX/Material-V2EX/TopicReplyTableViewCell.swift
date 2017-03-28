//
//  TopicReplyTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

fileprivate let scaleValue: CGFloat = UIScreen.main.scale

class TopicReplyTableViewCell: BaseWKWebViewTableViewCell, WKUIDelegate {
    // UI
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.isOpaque = true
        bgView.isUserInteractionEnabled = false
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = scaleValue
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowRadius = 0.75
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        return bgView
    }()
    
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.contentMode = .scaleToFill
        avatarView.isOpaque = true
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 3.33
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: Global.Config.regularFontName, size: 14.0)
        nameLabel.textColor = UIColor.black
        nameLabel.backgroundColor = UIColor.white
        nameLabel.isOpaque = true
        nameLabel.isUserInteractionEnabled = false
        nameLabel.layer.shouldRasterize = true
        nameLabel.layer.rasterizationScale = scaleValue
        return nameLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateLabel.textColor = Global.Config.infoTextColor
        dateLabel.backgroundColor = UIColor.white
        dateLabel.isOpaque = true
        dateLabel.isUserInteractionEnabled = false
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.rasterizationScale = scaleValue
        return dateLabel
    }()
    
    lazy var thanksIconLabel: UILabel = {
        let thanksIconLabel = UILabel()
        thanksIconLabel.font = UIFont.systemFont(ofSize: 12.0)
        thanksIconLabel.textColor = Global.Config.nodeTextColor
        thanksIconLabel.backgroundColor = UIColor.white
        thanksIconLabel.isOpaque = true
        thanksIconLabel.isUserInteractionEnabled = false
        thanksIconLabel.layer.shouldRasterize = true
        thanksIconLabel.layer.rasterizationScale = scaleValue
        thanksIconLabel.text = "♥"
        thanksIconLabel.textAlignment = .right
        thanksIconLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh + 1, for: .horizontal)
        return thanksIconLabel
    }()
    
    lazy var thanksCountLabel: UILabel = {
        let thanksCountLabel = UILabel()
        thanksCountLabel.font = UIFont.systemFont(ofSize: 12.0)
        thanksCountLabel.textColor = Global.Config.nodeTextColor
        thanksCountLabel.backgroundColor = UIColor.white
        thanksCountLabel.isOpaque = true
        thanksCountLabel.isUserInteractionEnabled = false
        thanksCountLabel.layer.shouldRasterize = true
        thanksCountLabel.layer.rasterizationScale = scaleValue
        return thanksCountLabel
    }()
    
    lazy var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = Global.Config.nodeTextBackgroundColor
        separatorLine.isOpaque = true
        return separatorLine
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        whiteView.isOpaque = true
        return whiteView
    }()
    
    lazy var whiteView2: UIView = {
        let whiteView2 = UIView()
        whiteView2.backgroundColor = UIColor.white
        whiteView2.isOpaque = true
        return whiteView2
    }()
    
    // Data
    var data: TopicReplyModel?
    var contentHeight: CGFloat = 0
    var contentHeightChanged: ((CGFloat, IndexPath?) -> Void)?  // 这里还需要加一个indexPath作为判断依据，因为cell的复用特性，有可能导致这个cell被复用了才触发上一批数据的回调，导致高度显示错误
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scaleValue
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = scaleValue
        contentView.backgroundColor = Global.Config.backgroundColor
        self.webView.uiDelegate = self
        
        contentView.addSubview(bgView)
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(thanksIconLabel)
        contentView.addSubview(thanksCountLabel)
        contentView.addSubview(webView)
        contentView.addSubview(whiteView)
        contentView.addSubview(whiteView2)
        contentView.addSubview(separatorLine)
        
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarTapped(sender:)))
        avatarView.addGestureRecognizer(tapAvatar)
        
        setConstraints()
        
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let change = change, let size = change[NSKeyValueChangeKey.newKey] as? NSValue {
                contentHeight = size.cgSizeValue.height
                if let cb = contentHeightChanged {
                    cb(contentHeight + 68, indexPath)
                }
            }
        }
    }

    func setConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(6)
            make.left.equalTo(bgView).offset(8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(6)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.height.equalTo(17)
            make.right.greaterThanOrEqualTo(thanksIconLabel.snp.left).offset(-10)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalTo(bgView).offset(-8)
            make.height.equalTo(15)
        }
        thanksIconLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        thanksCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(10)
            make.left.equalTo(thanksIconLabel.snp.right).offset(3)
            make.height.equalTo(15)
            make.width.equalTo(28)
            make.right.equalTo(bgView).offset(-5)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.left.equalTo(bgView).offset(8)
            make.right.equalTo(bgView).offset(-8)
            make.bottom.equalTo(bgView).offset(-6)
        }
        whiteView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(2)
        }
        whiteView2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(2)
        }
        separatorLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(bgView).offset(5)
            make.right.equalTo(bgView).offset(-5)
            make.height.equalTo(1)
        }
    }
    
    func avatarTapped(sender: UITapGestureRecognizer) {
        if let data = data, let indexPath = indexPath {
            let topicViewController = viewController(ofView: self) as! TopicDetailViewController
            topicViewController.openMember(data: data.author, indexPath: indexPath)
        }
    }
    
    func setData(data: TopicReplyModel, indexPath: IndexPath) {
        self.contentHeight = 0
        self.contentHeightChanged = nil
        self.data = data
        self.indexPath = indexPath
        
        avatarView.setImageWith(url: (data.author.avatarURL))
        nameLabel.text = data.author.username
        dateLabel.text = data.date
        if data.thanks.characters.count > 0 {
            thanksIconLabel.isHidden = false
        } else {
            thanksIconLabel.isHidden = true
        }
        thanksCountLabel.text = data.thanks
        
        webView.loadHTMLString(data.content, baseURL: nil)
    }
}
