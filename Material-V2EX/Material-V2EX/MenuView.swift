//
//  menuView.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/21.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit
import Material

fileprivate let buttonUnSelectBackgroundColor = UIColor.white.withAlphaComponent(0.24)
fileprivate let buttonSelectBackgroundColor = UIColor.white.withAlphaComponent(0.38)

class MenuView: UIView {
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var panelViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var mainButton: RaisedButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topicListButton: FlatButton!
    @IBOutlet weak var allNodeButton: FlatButton!
    @IBOutlet weak var myTopicButton: FlatButton!
    @IBOutlet weak var aboutButton: FlatButton!
    @IBOutlet weak var settingButton: FlatButton!
    
    static let shared = Bundle.main.loadNibNamed(Global.Views.menuView, owner: nil, options: nil)?.first as! MenuView
    var selectedButton: FlatButton! {
        willSet {
            if selectedButton != nil {
                selectedButton.backgroundColor = buttonUnSelectBackgroundColor
            }
            newValue.backgroundColor = buttonSelectBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        let bgView = UIImageView(image: UIImage(named: "menuview_bg"))
        bgView.frame = panelView.frame
        self.panelView.layer.insertSublayer(bgView.layer, at: 0)
        self.avatarView.layer.borderColor = UIColor.white.cgColor
        selectedButton = topicListButton
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginStatusChangedHandler),
                                               name: Global.Notifications.kLoginStatusChanged,
                                               object: nil)
        
        loginStatusChanged()
        setupGesture()
    }
    
    func setupGesture() {
        let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(handlePanel(sender:)))
        self.addGestureRecognizer(swipeLeft)
        let tap = UITapGestureRecognizer(target: self, action: #selector(backHome(sender:)))
        bgView.addGestureRecognizer(tap)
        let tapMainBtn = UITapGestureRecognizer(target: self, action: #selector(mainButtonTapped(sender:)))
        mainButton.addGestureRecognizer(tapMainBtn)
        let tapTopicList = UITapGestureRecognizer(target: self, action: #selector(topicListTapped(sender:)))
        topicListButton.addGestureRecognizer(tapTopicList)
        let tapAllNode = UITapGestureRecognizer(target: self, action: #selector(allNodeTapped(sender:)))
        allNodeButton.addGestureRecognizer(tapAllNode)
        let tapMyTopic = UITapGestureRecognizer(target: self, action: #selector(myTopicTapped(sender:)))
        myTopicButton.addGestureRecognizer(tapMyTopic)
        let tapAbout = UITapGestureRecognizer(target: self, action: #selector(aboutTapped(sender:)))
        aboutButton.addGestureRecognizer(tapAbout)
        let tapSetting = UITapGestureRecognizer(target: self, action: #selector(settingTapped(sender:)))
        settingButton.addGestureRecognizer(tapSetting)
    }
    
    func backHome(sender: UITapGestureRecognizer) {
        hideMenu(self)
    }
    
    func handlePanel(sender: UIPanGestureRecognizer) {
        handleMenu(self, recognizer: sender)
    }
    
    func mainButtonTapped(sender: UITapGestureRecognizer) {
        hideMenu(self)
        
        if User.shared.isLogin {
            User.shared.logout()
            let _ = ToastManager.shared.showToast(toView: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: "账号已注销", position: .bottom)
        } else {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Global.ViewControllers.login) as! LoginViewController
            let homeViewController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[0] as! HomeViewController
            loginViewController.modalDelegate = homeViewController
            homeViewController.tr_presentViewController(loginViewController, method: TRPresentTransitionMethod.twitter)
        }
    }
    
    func topicListTapped(sender: UITapGestureRecognizer) {
        selectedButton = topicListButton
    }
    
    func allNodeTapped(sender: UITapGestureRecognizer) {
        selectedButton = allNodeButton
    }
    
    func myTopicTapped(sender: UITapGestureRecognizer) {
        selectedButton = myTopicButton
    }
    
    func aboutTapped(sender: UITapGestureRecognizer) {
        selectedButton = aboutButton
    }
    
    func settingTapped(sender: UITapGestureRecognizer) {
        selectedButton = settingButton
    }
    
    func loginStatusChangedHandler(notification: Notification) {
        loginStatusChanged()
    }
    
    func loginStatusChanged() {
        self.usernameLabel.text = User.shared.username
        
        if User.shared.avatarURL.characters.count > 0 {
            self.avatarView.setImageWith(url: User.shared.avatarURL)
        } else {
            self.avatarView.image = UIImage(named: "default_avatar")
        }
        
        self.mainButton.title = User.shared.isLogin ? "登出" : "登录"
    }
}

