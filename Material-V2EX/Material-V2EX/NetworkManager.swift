//
//  NetworkManager.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/23.
//  Copyright © 2016年 altair21. All rights reserved.
//

import Alamofire
import SwiftyJSON

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
    
    func getLatestTopics(success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.latestTopics, parameters: [:], success: success, failure: failure)
    }
    
    func getHotTopics(success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.hotTopics, parameters: [:], success: success, failure: failure)
    }
    
    func getTopicsInNodes(id: Int, success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.topicsInNode, parameters: ["id": id, "name": ""], success: success, failure: failure)
    }
    
    
    func getTopicReplies(topicId: Int, success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.topicReplies, parameters: ["topic_id": topicId, "page": "", "page_size": ""], success: success, failure: failure)
    }
}
