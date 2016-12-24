//
//  MemberModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON

class MemberModel: NSObject {
    var id = 0
    var username = ""
    var avatarURL = ""
    
    init(data: JSON) {
        id = data["id"].intValue
        username = data["username"].stringValue
        avatarURL = "https:" + data["avatar_normal"].stringValue
    }
}
