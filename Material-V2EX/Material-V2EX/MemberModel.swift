//
//  MemberModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON

class MemberModel: NSObject {
    var username = ""
    var avatarURL = ""
    
    init(data: JSON) {
        username = data["username"].stringValue
        avatarURL = "https:" + data["avatar_normal"].stringValue
    }
}
