//
//  V2EX.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class V2EX: NSObject {
    private static let APIbasicURL = "https://www.v2ex.com/api"
    
    struct API {
        static let latestTopics = V2EX.APIbasicURL + "/topics/latest.json"
        static let hotTopics = V2EX.APIbasicURL + "/topics/hot.json"
        static let topicsInNode = V2EX.APIbasicURL + "/nodes/show.json"
        
        static let topicReplies = V2EX.APIbasicURL + "/replies/show.json"
    }
}
