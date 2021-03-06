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
    
    // MARK: Topic Module
    /// 根据页面内容解析出TopicOverviewModel数组
    ///
    /// - Parameters:
    ///   - jiDoc: 完整页面的Ji对象
    ///   - category: 列表类型，`?tab=xxx`和`/go/xxx`的布局略有不同
    /// - Returns: 返回值是元组：(处理结果, 结果数组)
    private func commonParseTopicList(jiDoc: Ji, category: TopicOverviewCategory) -> (Bool, Array<TopicOverviewModel>?) {
        let cellClass = (category == .group) ? "cell item" : "cell"
        if let topicOverviewNodes = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='" + cellClass + "']") {
            var res = Array<TopicOverviewModel>()
            for node in topicOverviewNodes {
                res.append(TopicOverviewModel(data: node, category: category))
            }
            return (true, res)
        } else {
            return (false, nil)
        }
    }
    
    /// 获取今日热议话题，唯一用到API的地方
    ///
    /// - Parameters:
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
    func getHotTopics(success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(V2EX.API.hotTopics, parameters: [:]).responseData { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    var res = Array<TopicOverviewModel>()
                    do {
                        for (_, item) in try JSON(data: data) {
                            res.append(TopicOverviewModel(data: item))
                        }
                    } catch let error as NSError {
                        failure(error.description)
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
    
    /// 获取不可翻页的节点的话题列表
    ///
    /// - Parameters:
    ///   - href: 请求url
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
    func getTopicsInGroupNodes(href: String, success: @escaping (Array<TopicOverviewModel>)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(href, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                let (resFlag, resArray) = self.commonParseTopicList(jiDoc: jiDoc, category: .group)
                if resFlag {
                    success(resArray!)
                } else {
                    failure("数据解析失败！")
                }
                
                // 默认领取登录奖励
                DispatchQueue.global(qos: .background).async {
                    let aNode = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='inner']/a")?.first
                    if aNode?.content == "领取今日的登录奖励" {
                        self.getDailyRedeem(success: {
                            let _ = ToastManager.shared.showToast(toView: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: "已领取每日登录奖励", position: .bottom)
                        }, failure: { (error) in
                            print("get daily redeem failure ", error)
                        })
                    }
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    /// 获取可翻页的节点的话题列表
    ///
    /// - Parameters:
    ///   - href: 请求url
    ///   - page: 请求页码
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
    func getTopicsInUnitNodes(href: String, page: Int, success: @escaping (Array<TopicOverviewModel>, Int)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(href + "?p=\(page)", headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                var nodeName = ""
                if let nodeTitle = jiDoc.xPath("//body/div[@id='Wrapper']/div/div/div[1]")?.first?.content {
                    if let range = nodeTitle.range(of: "›") {
                        let substrRange = Range(uncheckedBounds: (lower: range.upperBound, upper: nodeTitle.endIndex))
                        nodeName = nodeTitle.substring(with: substrRange).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                }
                let category: TopicOverviewCategory = href.hasPrefix("https://www.v2ex.com/recent") ? .group : .unit    // ”最近“节点的解析方式和其它节点不一样
                let (resFlag, resArray) = self.commonParseTopicList(jiDoc: jiDoc, category: category)
                var totalPage = 1
                if let pageStr = jiDoc.xPath("//body/div[@id='Wrapper']/div/div/div[@class='inner']/table/tr/td[2]/strong")?.first?.content {
                    if let range = pageStr.range(of: "/") {
                        let substrRange = Range(uncheckedBounds: (lower: range.upperBound, upper: pageStr.endIndex))
                        totalPage = Int(pageStr.substring(with: substrRange)) ?? 1
                    }
                }
                if resFlag {
                    if category == .unit {  // 除了”最近“节点的其它节点需要更新节点信息，因为解析数据时得不到
                        let node = NodeModel(name: nodeName, href: href, category: .unit)
                        for item in resArray! {
                            item.node = node
                        }
                    }
                    success(resArray!, totalPage)
                } else {
                    failure("数据解析失败！")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    /// 获取帖子内容及当前页的评论
    ///
    /// - Parameters:
    ///   - url: 请求url
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
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
    
    /// 获取相应url的所有评论信息
    ///
    /// - Parameters:
    ///   - url: 请求url，需拼接好页码参数
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
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
    
    // MARK: User Module
    /// 登录前获取验证码图片
    ///
    /// - Parameters:
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
    func prepareForLogin(success: @escaping (String, String, String, String, Data) -> Void, failure: @escaping (String) -> Void) {
        let loginURL = V2EX.indexURL + "/signin"
        
        // 进入登录页 获取哈希值
        Alamofire.request(loginURL, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                let jiDoc = Ji(htmlString: response.result.value!)!
                if let form = jiDoc.xPath("//body/div[@id='Wrapper']/div[1]/div[1]/div[2]/form/table")?.first {
                    if let t_once = form.xPath("tr[2]/td[2]/input[@name='once']").first?["value"],
                        let t_usernameSHA = form.xPath("tr[1]/td[2]/input").first?["name"],
                        let t_passwordSHA = form.xPath("tr[2]/td[2]/input[@class='sl']").first?["name"],
                        let t_authSHA = form.xPath("tr[4]/td[2]/input[@class='sl']").first?["name"] {
                        let authImageURL = V2EX.indexURL + "/_captcha?once=\(t_once)"
                        Alamofire.request(authImageURL).responseData(completionHandler: { (dataResp) in
                            if let data = dataResp.data {
                                success(t_once, t_usernameSHA, t_passwordSHA, t_authSHA, data)
                            } else {
                                failure("验证码解析失败")
                            }
                        })
                    } else {
                        failure("验证码解析失败")
                        return
                    }
                } else {
                    failure("获取验证码失败")
                    return
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
                return
            }
        }
    }
    
    /// 发送登录请求
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    ///   - success: 处理成功回调
    ///   - failure: 处理失败回调
    func loginWith(once: String, userSHA: String, pwdSHA: String, authSHA: String, username: String, password: String, auth: String, success: @escaping (String, String)->Void, failure: @escaping (String)->Void ) {
        let loginURL = V2EX.indexURL + "/signin"
        
        print(once, userSHA, pwdSHA, authSHA, username, password, auth)
        // 发送登录请求
        let parameters = [
            "next": "/",
            "once": once,
            userSHA: username,
            pwdSHA: password,
            authSHA: auth,
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
        }
    }
    
    /// 领取每日登录奖励
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failure: 失败回调
    private func getDailyRedeem(success: @escaping ()->(), failure: @escaping (String)->()) {
        Alamofire.request(V2EX.indexURL + "/mission/daily", headers: Global.Config.requestHeader).responseString { (response) in
            if response.request?.url?.absoluteString == response.response?.url?.absoluteString {
                let jiDoc = Ji(htmlString: response.result.value!)!
                let inputNode = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='cell'][2]/input")?.first
                if let onclickStr = inputNode?.attributes["onclick"],
                   let firstIndex = onclickStr.range(of: "'") {
                    let dirtyURL = onclickStr.substring(from: firstIndex.upperBound)
                    if let secondIndex = dirtyURL.range(of: "'") {
                        let url = dirtyURL.substring(to: secondIndex.lowerBound)
                        Alamofire.request(V2EX.indexURL + url, headers: Global.Config.requestHeader).responseString(completionHandler: { (res) in
                            if let jiDoc = Ji(htmlString: res.result.value!) {
                                let node = jiDoc.xPath("//body/div[@id='Wrapper']/div/div/div[@class='message']")?.first
                                if (node?.content == "已成功领取每日登录奖励") {
                                    success()
                                }
                            } else {
                                failure("领取失败！")
                            }
                        })
                    } else {
                        failure("解析失败！")
                    }
                } else {
                    failure("解析失败")
                }
            } else {
                failure("没有登录！")
            }
        }
    }
    
    // MARK: Member Module
    /// 访问用户主页
    ///
    /// - Parameters:
    ///   - url: 完整url
    ///   - success: 成功回调
    ///   - failure: 失败回调
    func getMember(url: String, success: @escaping (Ji)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(url, headers: Global.Config.requestHeader).responseString { (response) in
            switch response.result {
            case .success:
                if let jiDoc = Ji(htmlString: response.result.value!) {
                    success(jiDoc)
                } else {
                    failure("解析失败！")
                }
            case .failure:
                failure(response.result.error?.localizedDescription ?? "网络错误")
            }
        }
    }
    
    // MARK: Node Module
    /// 获取所有节点信息
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failure: 失败回调
    func getAllNodes(success: @escaping (Array<NodeGroupModel>)->Void, failure: @escaping (String)->Void) {
        Alamofire.request(V2EX.indexURL + "/planes", headers: Global.Config.requestHeader).responseString { (response) in
            if let jiDoc = Ji(htmlString: response.result.value!),
                let boxNodes = jiDoc.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']") {
                let handleNodes = boxNodes.dropFirst()
                var res = [NodeGroupModel]()
                for boxNode in handleNodes {
                    res.append(NodeGroupModel(data: boxNode))
                }
                success(res)
            } else {
                failure(response.result.error?.localizedDescription ?? "解析失败")
            }
        }
    }
}


