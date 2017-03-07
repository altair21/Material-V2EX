//
//  MemberReplyModel.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import Ji

class MemberReplyModel: NSObject {
    var replyInfo = ""  // 字符串 “回复了xxx的主题”
    var topicTitle = ""
    var href = ""
    var date = ""
    var content = ""
    var renderContent: NSMutableAttributedString? = nil
    
    init(data: JiNode, replyNode: JiNode?) {
        super.init()
        
        if let infoNode = data.xPath("table/tr[1]/td/span").first {
            replyInfo = infoNode.content ?? "解析失败！"
            if let titleNode = infoNode.xPath("a").first {
                topicTitle = titleNode.content ?? "标题解析失败！"
                href = V2EX.indexURL + (titleNode["href"] ?? "")
                carveHref()
            }
        }
        if let dateNode = data.xPath("table/tr[1]/td/div/span").first {
            date = dateNode.content ?? "时间解析失败！"
        }
        
        if let replyNode = replyNode, let contentNode = replyNode.xPath("div").first {
            content = contentNode.rawContent ?? "内容解析失败！"
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
