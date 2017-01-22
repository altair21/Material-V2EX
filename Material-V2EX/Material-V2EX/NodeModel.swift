//
//  NodeModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON

class NodeModel: NSObject {
    var name = ""           // 用户拼接URL
    var href = ""           
    var title = ""          // 用于显示
    
    init(data: JSON) {
        super.init()
        name = data["name"].stringValue
        title = data["title"].stringValue
    }
}
