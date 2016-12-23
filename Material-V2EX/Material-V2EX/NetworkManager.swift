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
    static let sharedInstance = NetworkManager()
    
    private func commonRequest(api: String, success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(api).responseData { (response) in
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
        commonRequest(api: V2EX.API.latestTopics, success: success, failure: failure)
    }
    
    func getHotTopics(success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        commonRequest(api: V2EX.API.hotTopics, success: success, failure: failure)
    }
}
