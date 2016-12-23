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
    
    func getLatestTopics() {
        Alamofire.request(V2EX.API.latestTopics).responseJSON { (response) in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    func getHotTopics(success: @escaping (JSON)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(V2EX.API.hotTopics).responseData { (response) in
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
}
