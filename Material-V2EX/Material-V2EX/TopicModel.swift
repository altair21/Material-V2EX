//
//  TopicModel.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/20.
//  Copyright © 2017年 altair21. All rights reserved.
//

import Ji

class TopicModel: NSObject {
    var author: MemberModel!
    var nodeTitle = ""
    var title = ""
    var content = ""
    var renderContent: NSMutableAttributedString? = nil
    var totalReplies = ""                           // 回复数
    var dateAndClickCount = ""                      // 创建时间和点击次数
    var subtleContent = Array<TopicSubtleModel>()   // 内容, 时间
    var replies = Array<TopicReplyModel>()          // 回复
    var basicHref = ""                              // 不带页码的href
    var page = 1                                    // 当前页码
    var totalPages = 1                              // 总页码数

    init(data: JiNode) {
        super.init()
        let headerNode = data.xPath("div[@class='box'][1]/div[@class='header']").first
        let authorANode = headerNode?.xPath("div[@class='fr']/a").first
        let authorHref = V2EX.indexURL + (authorANode?["href"] ?? "")
        let authorAvatarURL = "https:" + (authorANode?.xPath("img").first?["src"] ?? "")
        let authorName = headerNode?.xPath("small/a").first?.content ?? "昵称获取失败！"
        author = MemberModel(username: authorName, avatarURL: authorAvatarURL, href: authorHref)
        nodeTitle = headerNode?.xPath("a[2]").first?.content ?? "节点获取失败！"
        title = headerNode?.xPath("h1").first?.content ?? "标题获取失败"
        content = Global.Config.webDocumentPreset + (data.xPath("div[1]/div[@class='cell']/div").first?.rawContent ?? "")   // 无正文内容
        totalReplies = data.xPath("div[3]/div/span/text()[1]").first?.content ?? "0 回复"
        dateAndClickCount = headerNode?.xPath("small/text()[2]").first?.content ?? "创建时间获取失败"
        
        let subtles = data.xPath("div[1]/div[@class='subtle']")
        for subtle in subtles {
            let date = subtle.xPath("span").first?.content ?? "时间获取失败！"
            let content = subtle.xPath("div[@class='topic_content']").first?.rawContent ?? "内容获取失败！"
            subtleContent.append(TopicSubtleModel(date: date, content: content))
        }
        
        let repliesNode = data.xPath("div[3]/div[@id]")
        for reply in repliesNode {
            replies.append(TopicReplyModel(data: reply))
        }
        if let pages = data.xPath("div[3]/div[last()]/a[last()]").first?.content, let pageCount = Int(pages) {
            totalPages = pageCount
        }
    }
}
