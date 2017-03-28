//
//  TopicSubtleTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/22.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

fileprivate let scaleValue = UIScreen.main.scale

class TopicSubtleTableViewCell: BaseWKWebViewTableViewCell, WKUIDelegate {
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

    var contentHeight: CGFloat = 0
    var contentHeightChanged: ((CGFloat, IndexPath?) -> Void)?  // IndexPath的作用和TopicReplyTableViewCell中一样
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scaleValue
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = scaleValue
        contentView.backgroundColor = Global.Config.backgroundColor
        webView.uiDelegate = self
        
        contentView.addSubview(bgView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(webView)
        contentView.addSubview(whiteView)
        contentView.addSubview(whiteView2)
        contentView.addSubview(separatorLine)
        
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
                    cb(contentHeight + 39, indexPath)
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
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(6)
            make.left.equalTo(bgView).offset(10)
            make.right.equalTo(bgView).offset(-10)
            make.height.equalTo(15)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
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
    
    func setData(data: TopicSubtleModel, indexPath: IndexPath) {
        contentHeight = 0
        contentHeightChanged = nil
        dateLabel.text = data.date
        self.indexPath = indexPath
        
        webView.loadHTMLString(data.content, baseURL: nil)
    }

}
