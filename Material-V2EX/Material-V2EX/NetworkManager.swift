//
//  NetworkManager.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Ji

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    private func commonRequest(api: String, parameters: Dictionary<String, Any> , success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(api, parameters: parameters).responseData { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    var res = Array<TopicOverviewModel>()
                    for (_, item) in JSON(data: data) {
                        res.append(TopicOverviewModel(data: item))
                    }
                    success(res)
                } else {
                    failure("数据解析失败！")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    private func commonGetTopicList(url: String, success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(url, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                if let topicOverviewNodes = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='cell item']") {
                    var res = Array<TopicOverviewModel>()
                    for node in topicOverviewNodes {
                        res.append(TopicOverviewModel(data: node))
                    }
                    success(res)
                } else {
                    failure("数据解析失败！")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    func getHotTopics(success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.hotTopics, parameters: [:], success: success, failure: failure)
    }
    
    func getTopicsInNodes(code: String, success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        commonGetTopicList(url: V2EX.categoryBasicURL + code, success: success, failure: failure)
    }
    
    func getTopicDetail(url: String, success: @escaping (TopicModel)->Void, failure: @escaping (String)->Void ) {
        Alamofire.request(url, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                if let contentNode = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']")?.first {
                    let res = TopicModel(data: contentNode)
                    success(res)
                } else {
                    failure("数据解析失败！")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    func getTopicDetailComments(url: String, success: @escaping (Array<TopicReplyModel>)->Void, failure: @escaping (String)->Void ) {
        Alamofire.request(url, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                if let repliesNode = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[3]/div[@id]") {
                    var res = Array<TopicReplyModel>()
                    for reply in repliesNode {
                        res.append(TopicReplyModel(data: reply))
                    }
                    success(res)
                } else {
                    failure("数据解析失败")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    func getTopicReplies(topicId: Int, success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
//        commonRequest(api: V2EX.API.topicReplies, parameters: ["topic_id": topicId, "page": "", "page_size": ""], success: success, failure: failure)
    }
}
