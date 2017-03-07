//
//  TopicOverviewModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON
import Ji

enum TopicOverviewCategory {
    case group
    case unit
}

class TopicOverviewModel: NSObject {
    var id = 0
    var href = ""                           // 话题URL
    var title = ""
    var replies = 0                         // 回复数
    var created: TimeInterval = 0
    var last_modified: TimeInterval = 0
    var last_modifiedText = ""              // last_modified转为文字
    var author: MemberModel!
    var node: NodeModel?
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
        node = NodeModel(name: data["node"]["title"].stringValue, href: data["node"]["title"].stringValue, category: .unit)
    }
    
    init(data: JiNode, category: TopicOverviewCategory) {    // 通过解析HTML初始化，用来显示除了每日热议的其它列表
        super.init()
        
        let titleNode = data.xPath("table/tr/td[3]/span[@class='item_title']/a").first
        href = V2EX.indexURL + (titleNode?["href"] ?? "")
        carveHref()
        title = titleNode?.content ?? "标题获取失败！"
        replies = Int(data.xPath("table/tr/td[4]/a").first?.content ?? "0") ?? 0
        
        switch category {
        case .group:
            initGroupCategory(data: data)
        case .unit:
            initUnitCategory(data: data)
        }
    }
    
    func initGroupCategory(data: JiNode) {
        let timeText = data.xPath("table/tr/td[3]/span[3]").first?.content ?? "未知"
        if let range = timeText.range(of: "  •  ") {    // 不显示最后回复者
            last_modifiedText = timeText.substring(to: range.lowerBound)
        } else {
            last_modifiedText = timeText
        }
        
        let authorAvatarURL = "https:" + ((data.xPath("table/tr/td[1]/a/img").first?["src"]) ?? "")
        let authorNode = data.xPath("table/tr/td[3]/span[1]/strong/a").first
        let authorName = authorNode?.content ?? "昵称获取失败！"
        let authorHref = V2EX.indexURL + (authorNode?["href"] ?? "")
        author = MemberModel(username: authorName, avatarURL: authorAvatarURL, href: authorHref)
        
        let nodeNode = data.xPath("table/tr/td[3]/span[1]/a").first
        let nodeTitle = nodeNode?.content ?? "节点获取失败！"
        let nodeHref = V2EX.indexURL + (nodeNode?["href"] ?? "")
        node = NodeModel(name: nodeTitle, href: nodeHref, category: .unit)
    }
    
    func initUnitCategory(data: JiNode) {
        let infoNode = data.xPath("table/tr/td[3]/span[2]").first
        let infoText = infoNode?.content ?? "未知"
        if let range = infoText.range(of: "  •  ", options: String.CompareOptions.backwards, range: nil, locale: nil) {
            let substrRange = Range(uncheckedBounds: (lower: range.upperBound, upper: infoText.endIndex))
            last_modifiedText = infoText.substring(with: substrRange)
        } else {
            last_modifiedText = infoText
        }
        
        let authorAvatarURL = "https:" + ((data.xPath("table/tr/td[1]/a/img").first?["src"]) ?? "")
        let authorName = infoNode?.xPath("strong").first?.content ?? "昵称获取失败！"
        let authorHref = V2EX.indexURL + (data.xPath("table/td/td[1]/a").first?["href"] ?? "")
        author = MemberModel(username: authorName, avatarURL: authorAvatarURL, href: authorHref)
    }
    
    func carveHref() {  // 优先进入第一页回复
        if let range = href.range(of: "#") {    // 去除"#replay"字符串
            href = href.substring(to: range.lowerBound) + "?p=1"
        } else {
            href = href + "?p=1"
        }
    }
    
}
