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
    
    // MARK: Topic Module
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
    
    // MARK: User Module
    func loginWith(username: String, password: String, success: @escaping (String, String)->Void, failure: @escaping (String)->Void ) {
        let loginURL = V2EX.indexURL + "/signin"
        var usernameSHA = ""
        var passwordSHA = ""
        var once = ""
        
        // 发送登录请求
        let loginRequest = {
            let parameters = [
                "next": "/",
                "once": once,
                usernameSHA: username,
                passwordSHA: password
            ]
            var headers = Global.Config.requestHeader
            headers["referer"] = loginURL
            
            Alamofire.request(loginURL, method: .post, parameters: parameters, headers: headers).responseString { (response) in
                switch response.result {
                case .success:
                    let jiDoc = Ji(htmlString: response.result.value!)!
                    if let problem = jiDoc.xPath("//div[@class='problem']/ul/li")?.first?.content { // 登录失败
                        failure(problem)
                        return
                    }
                    if let avatarNode = jiDoc.xPath("//body/div[@id='Top']/div/div/table/tr/td[3]/a[1]")?.first {   // 有用户头像，说明登录成功
                        if let href = avatarNode["href"], let imageURL = avatarNode.xPath("img[1]").first?["src"] {
                            let largeImageURL = imageURL.replacingOccurrences(of: "normal", with: "large")
                            if href.hasPrefix("/member/") {
                                let username = href.replacingOccurrences(of: "/member/", with: "")
                                success(username, "https:" + largeImageURL)
                            } else {
                                // 已知情况下不会进入这里
                            }
                        }
                    } else {
                        failure("登录失败，未知原因")
                    }
                case .failure:
                    failure(response.result.error?.localizedDescription ?? "登录时网络错误")
                }
            }
        }
        
        // 进入登录页 获取哈希值
        Alamofire.request(loginURL, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                if let form = jiDoc.xPath("//body/div[@id='Wrapper']/div[1]/div[1]/div[2]/form/table")?.first {
                    if let t_once = form.xPath("tr[2]/td[2]/input[@name='once']").first?["value"],
                        let t_usernameSHA = form.xPath("tr[1]/td[2]/input").first?["name"],
                        let t_passwordSHA = form.xPath("tr[2]/td[2]/input[@class='sl']").first?["name"] {
                        
                        once = t_once
                        usernameSHA = t_usernameSHA
                        passwordSHA = t_passwordSHA
                        
                        loginRequest()
                    } else {
                        failure("解析错误")
                        return
                    }
                } else {
                    failure("解析错误")
                    return
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
                return
            }
        }
    }
    
    /// 验证登录状态
    ///
    /// - Parameters:
    ///   - success: 状态有效回调
    ///   - failure: 状态无效回调
    func verifyLoginStatus(success: @escaping ()->(), failure: @escaping ()->()) {
        Alamofire.request(V2EX.indexURL + "/new", headers: Global.Config.requestHeader).responseString { (response) in
            if response.request?.url?.absoluteString == response.response?.url?.absoluteString {
                success()
            } else {
                failure()
            }
            print(response.request?.url?.absoluteString)
            print(response.response?.url?.absoluteString)
        }
    }
}


