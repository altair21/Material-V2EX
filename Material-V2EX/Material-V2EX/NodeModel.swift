//
//  NodeModel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

class NodeModel: NSObject {
    enum NodeCategory {
        case group      // 首页节点，节点的合集
        case unit       // 全部节点中的每个独立节点
    }
    
    var name: String            // 节点名
    var href: String            // 节点url
    var category: NodeCategory  // 根据category拼装请求url，解析数据
    var canTurnPage: Bool { // 是否支持翻页
        get {
            return category == .unit
        }
    }
    var totalPage: Int = 1      // 节点话题列表总页数
    
    init(name: String, href: String, category: NodeCategory) {
        self.name = name
        if href == Global.Config.kTodayHottestHref {
            self.href = href
        } else {
            self.href = V2EX.indexURL + href
        }
        self.category = category
        
        super.init()
    }
    
    func loadTopics(ofPage page: Int = 1, success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void ) {
        if href == Global.Config.kTodayHottestHref {
            NetworkManager.shared.getHotTopics(success: success, failure: failure)
            return
        }
        if category == .group {
            NetworkManager.shared.getTopicsInGroupNodes(href: href, success: success, failure: failure)
        } else {
            NetworkManager.shared.getTopicsInUnitNodes(href: href, page: page, success: { (resArray, totalPage) in
                self.totalPage = totalPage
                print("总页数\(totalPage)")
                success(resArray)
            }, failure: failure)
        }
    }
}
