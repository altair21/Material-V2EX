//
//  NodeGroupModel.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/4.
//  Copyright © 2017年 altair21. All rights reserved.
//

class NodeGroupModel: NSObject {
    var title = ""
    var list = [NodeModel]()
    
    init(title: String, list: Array<NodeModel>) {
        super.init()
        self.title = title
        self.list = list
    }
}
