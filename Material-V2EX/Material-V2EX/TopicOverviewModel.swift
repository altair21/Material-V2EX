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
    var authorHref = ""                     // 作者URL
    var title = ""
    var replies = 0                         // 回复数
    var created: TimeInterval = 0
    var last_modified: TimeInterval = 0
    var last_modifiedText = ""              // last_modified转为文字
    var authorAvatar = ""                   // 作者头像URL
    var authorName = ""
    var nodeTitle = ""                      // 节点名称
    var isAnimated = false
    var markRead = false
    
    init(data: JSON) {  // 通过API初始化，用来显示每日热议
        id = data["id"].intValue
        href = V2EX.indexURL + "/t/" + String(id)
        title = data["title"].stringValue
        replies = data["replies"].intValue
        created = TimeInterval(data["created"].doubleValue)
        last_modified = TimeInterval(data["last_modified"].doubleValue)
        authorAvatar = "https:" + data["member"]["avatar_normal"].stringValue
        authorName = data["member"]["username"].stringValue
        authorHref = V2EX.indexURL + "/member/" + authorName
        nodeTitle = data["node"]["title"].stringValue
        nodeHref = V2EX.indexURL + "/go/" + data["node"]["name"].stringValue
    }
    
    init(data: JiNode) {    // 通过解析HTML初始化，用来显示除了每日热议的其它列表
        let titleNode = data.xPath("table/tr/td[3]/span[@class='item_title']/a").first
        href = V2EX.indexURL + (titleNode?["href"] ?? "")
        title = titleNode?.content ?? "标题获取失败！"
        replies = Int(data.xPath("//tr/td[3]/a").first?.content ?? "0") ?? 0
        
        let timeText = data.xPath("table/tr/td[3]/span[3]").first?.content ?? "未知"
        if let range = timeText.range(of: "  •  ") {    // 不显示最后回复者
            let substrRange = Range(uncheckedBounds: (lower: timeText.startIndex, upper: range.lowerBound))
            last_modifiedText = timeText.substring(with: substrRange)
        } else {
            last_modifiedText = timeText
        }
        
        authorAvatar = "https:" + ((data.xPath("table/tr/td[1]/a/img").first?["src"]) ?? "")
        let authorNode = data.xPath("table/tr/td[3]/span[1]/strong/a").first
        authorName = authorNode?.content ?? "无名氏"
        authorHref = V2EX.indexURL + (authorNode?["href"] ?? "")
        
        let nodeNode = data.xPath("table/tr/td[3]/span[1]/a").first
        nodeTitle = nodeNode?.content ?? "节点获取失败！"
        nodeHref = V2EX.indexURL + (nodeNode?["href"] ?? "")
    }
    
}
