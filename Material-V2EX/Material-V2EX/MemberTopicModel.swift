//
//  MemberTopicModel.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import Ji

class MemberTopicModel: NSObject {
    var nodeTitle = ""
    var title = ""
    var lastModifyText = ""
    var replies = 0
    var href = ""
    
    init(data: JiNode) {
        super.init()
        
        // TODO: 判断用户是否隐藏了主题
        if let nodeNode = data.xPath("table/tr/td[1]/span[1]/a").first {
            nodeTitle = nodeNode.content ?? "节点名解析失败！"
        }
        if let titleNode = data.xPath("table/tr/td[1]/span[2]/a").first {
            title = titleNode.content ?? "标题解析失败！"
            href = V2EX.indexURL + (titleNode["href"] ?? "")
            carveHref()
        }
        if let infoNode = data.xPath("table/tr/td[1]/span[3]/a").first {
            let timeText = infoNode.content ?? "解析失败！"
            if let range = timeText.range(of: "  •  ") {    // 不显示最后回复者
                lastModifyText = timeText.substring(to: range.lowerBound)
            } else {
                lastModifyText = timeText
            }
        }
        if let replyCountNode = data.xPath("table/tr/td[2]/a").first {
            replies = Int(replyCountNode.content ?? "0") ?? 0
        }
    }
    
    func carveHref() {  // 优先进入第一页回复
        if let range = href.range(of: "#") {    // 去除"#replay"字符串
            href = href.substring(to: range.lowerBound) + "?p=1"
        } else {
            href = href + "?p=1"
        }
    }
}
