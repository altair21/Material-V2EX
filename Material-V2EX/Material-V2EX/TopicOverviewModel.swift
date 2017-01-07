//
//  TopicOverviewModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON

class TopicOverviewModel: NSObject {
    var id = 0
    var title = ""
    var content = ""
    var replies = 0
    var created: TimeInterval = 0
    var last_modified: TimeInterval = 0
    var member: MemberModel?
    var node: NodeModel?
    var isAnimated = false
    var markRead = false
    
    init(data: JSON) {
        id = data["id"].intValue
        title = data["title"].stringValue
        content = data["content"].stringValue
        replies = data["replies"].intValue
        created = TimeInterval(data["created"].doubleValue)
        last_modified = TimeInterval(data["last_modified"].doubleValue)
        member = MemberModel(data: data["member"])
        node = NodeModel(data: data["node"])
    }
    
}
