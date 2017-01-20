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
    static let categoryBasicURL = "https://www.v2ex.com/?tab="
    private static let APIbasicURL = "https://www.v2ex.com/api"
    static let basicCategory = [("今日热议", Global.Config.kTodayHottestCode),
                                ("技术", "tech"),
                                ("创意", "creative"),
                                ("好玩", "play"),
                                ("Apple", "apple"),
                                ("酷工作", "jobs"),
                                ("交易", "deals"),
                                ("城市", "city"),
                                ("问与答", "qna"),
                                ("最热", "hot"),
                                ("全部", "all"),
                                ("R2", "r2")]
    
    struct API {
        static let latestTopics = V2EX.APIbasicURL + "/topics/latest.json"
        static let hotTopics = V2EX.APIbasicURL + "/topics/hot.json"
        static let topicsInNode = V2EX.APIbasicURL + "/nodes/show.json"
        
        static let topicReplies = V2EX.APIbasicURL + "/replies/show.json"
    }
}
