//
//  NodeGroupModel.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/4.
//  Copyright © 2017年 altair21. All rights reserved.
//

import Ji

class NodeGroupModel: NSObject {
    var title = ""
    var list = [NodeModel]()
    
    init(data: JiNode) {
        super.init()
        
        if let headerNode = data.xPath("div[@class='header']").first {
            title = headerNode.content ?? "UNKNOWN"
        }
        let aNodes = data.xPath("div[@class='inner']/a")
        for aNode in aNodes {
            let node = NodeModel(name: aNode.content ?? "节点名解析失败", href: aNode.attributes["href"] ?? "", category: .unit)
            list.append(node)
        }
    }
    
    init(title: String, list: Array<NodeModel>) {
        super.init()
        self.title = title
        self.list = list
    }
}
