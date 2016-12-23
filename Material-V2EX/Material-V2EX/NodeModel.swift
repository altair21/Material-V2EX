//
//  NodeModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON

class NodeModel: NSObject {
    var id = 0
    var name = ""
    var title = ""
    
    init(data: JSON) {
        id = data["id"].intValue
        name = data["name"].stringValue
        title = data["title"].stringValue
    }
}
