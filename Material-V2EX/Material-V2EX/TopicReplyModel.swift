//
//  TopicReplyModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/30.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON
import Ji

class TopicReplyModel: NSObject {
    var thanks = ""
    var content = ""
    var renderContent: NSMutableAttributedString? = nil
    var author: MemberModel!
    var date = ""
    
    init(data: JiNode) {
        super.init()
        thanks = data.xPath("table/tr/td[3]/span[2]").first?.content ?? ""
        if thanks.characters.count > 0 {    // 删掉“♥ ”前缀
            thanks.remove(at: thanks.startIndex)
            thanks.remove(at: thanks.startIndex)
        }
        content = Global.Config.webDocumentPreset + (data.xPath("table/tr/td[3]/div[@class='reply_content']").first?.rawContent ?? "内容获取失败！")
        let authorAvatarURL = "https:" + (data.xPath("table/tr/td[1]/img").first?["src"] ?? "")
        let authorNode = data.xPath("table/tr/td[3]/strong/a").first
        let authorHref = V2EX.indexURL + (authorNode?["href"] ?? "")
        let authorName = authorNode?.content ?? "昵称获取失败！"
        author = MemberModel(username: authorName, avatarURL: authorAvatarURL, href: authorHref)
        date = data.xPath("table/tr/td[3]/span[1]").first?.content ?? "时间获取失败！"
        
    }
}
