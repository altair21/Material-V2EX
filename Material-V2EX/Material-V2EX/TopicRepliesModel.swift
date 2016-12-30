//
//  TopicRepliesModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/30.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON

class TopicRepliesModel: NSObject {
    var id = 0
    var thanks = 0
    var content = ""
    var member: MemberModel?
    var created: TimeInterval = 0
    var last_modified: TimeInterval = 0
    
    init(data: JSON) {
        id = data["id"].intValue
        thanks = data["thanks"].intValue
        content = data["content"].stringValue
        member = MemberModel(data: data["member"])
        created = TimeInterval(data["created"].doubleValue)
        last_modified = TimeInterval(data["last_modified"].doubleValue)
    }
}
