//
//  TopicOverviewModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON
import Ji

class TopicOverviewModel: NSObject {
    var id = 0
    var href = ""                           // 话题URL
    var nodeHref = ""                       // 节点URL
    var title = ""
    var replies = 0                         // 回复数
    var created: TimeInterval = 0
    var last_modified: TimeInterval = 0
    var last_modifiedText = ""              // last_modified转为文字
    var author: MemberModel!
    var nodeTitle = ""                      // 节点名称
    var isAnimated = false
    var markRead = false
    
    init(data: JSON) {  // 通过API初始化，用来显示每日热议
        super.init()
        id = data["id"].intValue
        href = V2EX.indexURL + "/t/" + String(id)
        carveHref()
        title = data["title"].stringValue
        replies = data["replies"].intValue
        created = TimeInterval(data["created"].doubleValue)
        last_modified = TimeInterval(data["last_modified"].doubleValue)
        author = MemberModel(data: data["member"])
        nodeTitle = data["node"]["title"].stringValue
        nodeHref = V2EX.indexURL + "/go/" + data["node"]["name"].stringValue
    }
    
    init(data: JiNode) {    // 通过解析HTML初始化，用来显示除了每日热议的其它列表
        super.init()
        let titleNode = data.xPath("table/tr/td[3]/span[@class='item_title']/a").first
        href = V2EX.indexURL + (titleNode?["href"] ?? "")
        carveHref()
        title = titleNode?.content ?? "标题获取失败！"
        replies = Int(data.xPath("table/tr/td[4]/a").first?.content ?? "0") ?? 0
        
        let timeText = data.xPath("table/tr/td[3]/span[3]").first?.content ?? "未知"
        if let range = timeText.range(of: "  •  ") {    // 不显示最后回复者
            let substrRange = Range(uncheckedBounds: (lower: timeText.startIndex, upper: range.lowerBound))
            last_modifiedText = timeText.substring(with: substrRange)
        } else {
            last_modifiedText = timeText
        }
        
        let authorAvatarURL = "https:" + ((data.xPath("table/tr/td[1]/a/img").first?["src"]) ?? "")
        let authorNode = data.xPath("table/tr/td[3]/span[1]/strong/a").first
        let authorName = authorNode?.content ?? "昵称获取失败！"
        let authorHref = V2EX.indexURL + (authorNode?["href"] ?? "")
        author = MemberModel(username: authorName, avatarURL: authorAvatarURL, href: authorHref)
        
        let nodeNode = data.xPath("table/tr/td[3]/span[1]/a").first
        nodeTitle = nodeNode?.content ?? "节点获取失败！"
        nodeHref = V2EX.indexURL + (nodeNode?["href"] ?? "")
    }
    
    func carveHref() {  // 优先进入第一页回复
        if let range = href.range(of: "#") {    // 去除"#replay"字符串
            let substrRange = Range(uncheckedBounds: (lower: href.startIndex, upper: range.lowerBound))
            href = href.substring(with: substrRange) + "?p=1"
        } else {
            href = href + "?p=1"
        }
    }
    
}
