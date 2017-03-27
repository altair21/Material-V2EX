//
//  TopicAuthorTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

fileprivate let scaleValue = UIScreen.main.scale

class TopicAuthorTableViewCell: UITableViewCell, WKUIDelegate {
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
    
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.contentMode = .scaleToFill
        avatarView.isOpaque = true
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 3.33
        return avatarView
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
    
    lazy var nodeLabel: PaddingLabel = {
        let nodeLabel = PaddingLabel()
        nodeLabel.font = UIFont(name: Global.Config.regularFontName, size: 12.0)
        nodeLabel.textColor = Global.Config.nodeTextColor
        nodeLabel.backgroundColor = Global.Config.nodeTextBackgroundColor
        nodeLabel.isOpaque = true
        nodeLabel.layer.shouldRasterize = true
        nodeLabel.layer.rasterizationScale = scaleValue
        nodeLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh + 1, for: .horizontal)
        return nodeLabel
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.white
        webView.isOpaque = true
        return webView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        whiteView.isOpaque = true
        return whiteView
    }()
    
    // Data
    var data: TopicModel?
    var indexPath: IndexPath?
    var contentHeight: CGFloat = 0
    var contentHeightChanged: ((CGFloat) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scaleValue
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = scaleValue
        contentView.backgroundColor = Global.Config.backgroundColor
        contentView.addSubview(bgView)
        contentView.addSubview(nodeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(avatarView)
        contentView.addSubview(webView)
        contentView.addSubview(whiteView)
        
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
        if object as? UIScrollView == self.webView.scrollView && keyPath == "contentSize" {
            if let change = change, let size = change[NSKeyValueChangeKey.newKey] as? NSValue {
                if size.cgSizeValue.height <= contentHeight {
                    return
                }
                contentHeight = size.cgSizeValue.height
                if let cb = contentHeightChanged {
                    cb(contentHeight + 68)
                }
            }
        }
    }
    
    func setConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(0)
            make.bottom.equalTo(contentView).offset(-2)
            make.left.equalTo(contentView).offset(8)
            make.right.equalTo(contentView).offset(-8)
        }
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(8)
            make.left.equalTo(bgView).offset(8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(8)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.greaterThanOrEqualTo(nodeLabel.snp.left).offset(-10)
            make.height.equalTo(17)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalTo(bgView).offset(-10)
        }
        nodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(8)
            make.right.equalTo(bgView).offset(-8)
            make.height.equalTo(20)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.left.equalTo(bgView).offset(8)
            make.right.equalTo(bgView).offset(-8)
            make.bottom.equalTo(bgView).offset(-6)
        }
        whiteView.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
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
        
        webView.loadHTMLString(data.content, baseURL: nil)
    }
}

extension TopicAuthorTableViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

