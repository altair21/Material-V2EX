//
//  User.swift
//  Material-V2EX
//
//  Created by altair21 on 17/2/9.
//  Copyright © 2017年 altair21. All rights reserved.
//

class User: NSObject {
    static let shared = User()
    
    private var once: String?   // 用户操作凭证
    
    var isLogin = false
    var username = ""
    var avatarURL = ""
    
    func setLogin(username: String, avatarURL: String) {
        self.isLogin = true
        self.username = username
        self.avatarURL = avatarURL
        
        NotificationCenter.default.post(name: Global.Notifications.kLoginStatusChanged, object: nil)
    }
    
    func logout() {
        self.username = ""
        self.avatarURL = ""
        self.isLogin = false
        
        // 清除cookie
        if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: V2EX.indexURL)!) {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        NotificationCenter.default.post(name: Global.Notifications.kLoginStatusChanged, object: nil)
    }

}
