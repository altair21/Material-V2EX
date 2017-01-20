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
    
    private func commonRequest(api: String, parameters: Dictionary<String, Any> , success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(api, parameters: parameters).responseData { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    success(JSON(data: data))
                } else {
                    failure("数据解析失败！")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    private func commonGetTopicList(success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        Alamofire.request("https://www.v2ex.com/?tab=tech", headers: Global.Constants.requestHeader).responseString { (response) in
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
    
    func getLatestTopics(success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        commonGetTopicList(success: success, failure: failure)
//        commonRequest(api: V2EX.API.latestTopics, parameters: [:], success: success, failure: failure)
    }
    
    func getHotTopics(success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
//        commonRequest(api: V2EX.API.hotTopics, parameters: [:], success: success, failure: failure)
    }
    
    func getTopicsInNodes(id: Int, success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
//        commonRequest(api: V2EX.API.topicsInNode, parameters: ["id": id, "name": ""], success: success, failure: failure)
    }
    
    func getTopicReplies(topicId: Int, success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.topicReplies, parameters: ["topic_id": topicId, "page": "", "page_size": ""], success: success, failure: failure)
    }
}
