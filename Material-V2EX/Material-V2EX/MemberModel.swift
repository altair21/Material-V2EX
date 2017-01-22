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
    var href = ""           // 用户首页链接
    
    init(data: JSON) {
        super.init()
        username = data["username"].stringValue
        avatarURL = "https:" + data["avatar_normal"].stringValue
        href = V2EX.indexURL + "/member/" + username
    }
    
    init(username: String, avatarURL: String, href: String) {
        super.init()
        self.username = username
        self.avatarURL = avatarURL
        self.href = href
    }
}
