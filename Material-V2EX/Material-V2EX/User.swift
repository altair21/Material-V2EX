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
    
    override init() {
        super.init()
        
        (self.username, self.avatarURL) = self.getInfo()
        print(self.username, self.avatarURL)
        if self.username.characters.count > 0 {
            self.isLogin = true
        }
        verifyLoginStatus()
    }
    
    func setLogin(username: String, avatarURL: String) {
        self.isLogin = true
        self.username = username
        self.avatarURL = avatarURL
        self.saveInfo()
        
        NotificationCenter.default.post(name: Global.Notifications.kLoginStatusChanged, object: nil)
    }
    
    func logout() {
        self.username = ""
        self.avatarURL = ""
        self.isLogin = false
        self.cleanInfo()
        
        // 清除cookie
        if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: V2EX.indexURL)!) {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        NotificationCenter.default.post(name: Global.Notifications.kLoginStatusChanged, object: nil)
    }
    
    private func verifyLoginStatus() {
        NetworkManager.shared.verifyLoginStatus(success: {
            
        }, failure: {
            self.logout()
        })
    }

}

// MARK: User info storage
fileprivate let kUsername = "com.altair21.v2ex.storage.username"
fileprivate let kAvatarURL = "com.altair21.v2ex.storage.avatarurl"
extension User {
    fileprivate func getInfo() -> (String, String) {
        let username = UserDefaults.standard.string(forKey: kUsername)
        let avatarURL = UserDefaults.standard.string(forKey: kAvatarURL)
        return (username ?? "", avatarURL ?? "")
    }
    
    fileprivate func saveInfo() {
        UserDefaults.standard.set(self.username, forKey: kUsername)
        UserDefaults.standard.set(self.avatarURL, forKey: kAvatarURL)
    }
    
    fileprivate func cleanInfo() {
        UserDefaults.standard.removeObject(forKey: kUsername)
        UserDefaults.standard.removeObject(forKey: kAvatarURL)
    }
}
