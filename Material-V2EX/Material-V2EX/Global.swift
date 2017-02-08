//
//  Global.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/21.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

fileprivate let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

class Global: NSObject {
    // ViewControllers
    struct ViewControllers {
        static let menuView = "MenuViewController"
        static let topicDetail = "TopicDetailViewController"
    }
    
    // Views
    struct Views {
        static let menuView = "MenuView"
        static let nodeListView = "NodeListView"
        static let nodeListTableViewCell = "NodeListTableViewCell"
    }
    
    // Cells
    struct Cells {
        static let topicOverview = "topicOverviewCell"
        static let topicAuthorCell = "topicAuthorCell"
        static let topicSubtleCell = "topicSubtleCell"
        static let topicReplyCountCell = "topicReplyCountCell"
        static let topicReplyCell = "topicReplyCell"
        static let topicBlankCell = "topicBlankCell"
        static let topicHeaderCell = "topicHeaderCell"
        static let topicFooterCell = "topicFooterCell"
        static let nodeListCell = "nodeListCell"
    }
    
    // Constant
    struct Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
    }
    
    // Config
    struct Config {
        static let edgePanGestureThreshold: CGFloat = 15    // 首页左滑右滑手势响应宽度
        static let renderContentMargin: CGFloat = 34     // 帖子详情内容Margin
        static let requestHeader = ["user-agent": userAgent]
        static let kTodayHottestCode = "k今日热议"
        static let startNode = V2EX.basicCategory[1]   // 初始话题 - 技术
    }
    
    // Notifications
    struct Notifications {
        
    }
}
