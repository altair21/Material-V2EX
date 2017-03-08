//
//  MemberModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import SwiftyJSON
import Ji

class MemberModel: NSObject {
    var username = ""
    var avatarURL = ""
    var href = ""           // 用户首页链接
    var joinNumber = ""     // V2EX会员序号
    var joinDate = ""       // 加入V2EX时间
    var topics = [MemberTopicModel]()
    var replies = [MemberReplyModel]()
    var isHideTopic = false
    
    init(data: JSON) {
        super.init()
        username = data["username"].stringValue
        avatarURL = "https:" + data["avatar_normal"].stringValue
        href = V2EX.indexURL + "/member/" + username
    }
    
    init(username: String, avatarURL: String, href: String) {
        super.init()
        self.username = username
        self.avatarURL = avatarURL
        self.href = href
    }
    
    func handleDetail(data: Ji) {
        if let tableNode = data.xPath("//body/div[@id='Wrapper']/div/div[1]/div[1]/table")?.first {
            if let avatarNode = tableNode.xPath("tr/td[1]/img").first, let src = avatarNode["src"] {
                avatarURL = "https:" + src
            }
            if let spanNode = tableNode.xPath("tr/td[3]/span[@class='gray']").first {
                let str = spanNode.content ?? "解析失败，解析失败"
                if let range = str.range(of: "，") {
                    joinNumber = str.substring(to: range.lowerBound)
                    joinDate = str.substring(from: range.upperBound)
                }
            }
        }
        
        if let lockNode = data.xPath("//body/div[@id='Wrapper']/div/div[3]/div[@class='inner']/table/tr[2]/td/span")?.first {
            if (lockNode.content?.range(of: "主题列表被隐藏")) != nil {
                isHideTopic = true
            }
        }
        
        if let topicNodes = data.xPath("//body/div[@id='Wrapper']/div/div[3]/div[@class='cell item']") {
            for node in topicNodes {
                topics.append(MemberTopicModel(data: node))
            }
        }
        
        if let replyNodes = data.xPath("//body/div[@id='Wrapper']/div/div[5]/div[@class='dock_area']") {
            for node in replyNodes {
                replies.append(MemberReplyModel(data: node, replyNode: node.nextSibling))
            }
        }
    }
    
    func getDetail(success: @escaping (MemberModel)->Void, failure: @escaping (String)->Void) {
        if joinNumber.characters.count > 0 {
            success(self)
        }
        NetworkManager.shared.getMember(url: href, success: { (data) in
            self.handleDetail(data: data)
            success(self)
        }) { (error) in
            failure(error)
        }
    }
}
