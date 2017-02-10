//
//  V2EX.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class V2EX: NSObject {
    static let indexURL = "https://www.v2ex.com"
    private static let APIbasicURL = "https://www.v2ex.com/api"
    static let basicCategory: Array<NodeModel> =
        [NodeModel(name: "今日热议", href: Global.Config.kTodayHottestHref, category: .group),
         NodeModel(name: "技术", href: "/?tab=tech", category: .group),
         NodeModel(name: "创意", href: "/?tab=creative", category: .group),
         NodeModel(name: "好玩", href: "/?tab=play", category: .group),
         NodeModel(name: "Apple", href: "/?tab=apple", category: .group),
         NodeModel(name: "酷工作", href: "/?tab=jobs", category: .group),
         NodeModel(name: "交易", href: "/?tab=deals", category: .group),
         NodeModel(name: "城市", href: "/?tab=city", category: .group),
         NodeModel(name: "问与答", href: "/?tab=qna", category: .group),
         NodeModel(name: "最热", href: "/?tab=hot", category: .group),
         NodeModel(name: "全部", href: "/?tab=all", category: .group),
         NodeModel(name: "R2", href: "/?tab=r2", category: .group)]
    static let personalCategory: Array<NodeModel> =
        [NodeModel(name: "最近", href: "/recent", category: .unit),
         NodeModel(name: "节点", href: "/?tab=nodes", category: .group),
         NodeModel(name: "关注", href: "/?tab=members", category: .group)]
    
    struct API {
        static let latestTopics = V2EX.APIbasicURL + "/topics/latest.json"
        static let hotTopics = V2EX.APIbasicURL + "/topics/hot.json"
        static let topicsInNode = V2EX.APIbasicURL + "/nodes/show.json"
        
        static let topicReplies = V2EX.APIbasicURL + "/replies/show.json"
    }
}
