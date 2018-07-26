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
fileprivate let buttonSelectBackgroundColor = UIColor.white.withAlphaComponent(0.48)

enum MenuViewSelectType {
    case topicList
    case allNodes
    case myTopic
    case about
    case setting
}

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
        
        selectedButton = topicListButton
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginStatusChangedHandler),
                                               name: Global.Notifications.kLoginStatusChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(unitNodeSelectHandler(notification:)),
                                               name: Global.Notifications.kUnitNodeSelectChanged,
                                               object: nil)
        
        setupUI()
        setupGesture()
        loginStatusChanged()
    }
    
    func setupUI() {
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        let bgView = UIImageView(image: UIImage(named: "menuview_bg"))
        bgView.frame = panelView.frame
        self.panelView.layer.insertSublayer(bgView.layer, at: 0)
        self.avatarView.layer.borderColor = UIColor.white.cgColor
        
        let imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16)
        topicListButton.imageEdgeInsets = imageEdgeInsets
        allNodeButton.imageEdgeInsets = imageEdgeInsets
        myTopicButton.imageEdgeInsets = imageEdgeInsets
        aboutButton.imageEdgeInsets = imageEdgeInsets
        settingButton.imageEdgeInsets = imageEdgeInsets
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
    
    @objc func backHome(sender: UITapGestureRecognizer) {
        hideMenu(self)
    }
    
    @objc func handlePanel(sender: UIPanGestureRecognizer) {
        handleMenu(self, recognizer: sender)
    }
    
    @objc func mainButtonTapped(sender: UITapGestureRecognizer) {
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
    
    func configureSelect(type: MenuViewSelectType) {
        var button: FlatButton
        switch type {
        case .topicList:
            button = topicListButton
        case .allNodes:
            button = allNodeButton
        case .myTopic:
            button = myTopicButton
        case .about:
            button = aboutButton
        case .setting:
            button = settingButton
        }
        
        selectedButton = button
        NotificationCenter.default.post(name: Global.Notifications.kMenuViewSelectChanged,
                                        object: nil,
                                        userInfo: ["type": type])
        hideMenu(self)
    }
    
    @objc func topicListTapped(sender: UITapGestureRecognizer) {
        configureSelect(type: .topicList)
    }
    
    @objc func allNodeTapped(sender: UITapGestureRecognizer) {
        configureSelect(type: .allNodes)
    }
    
    @objc func myTopicTapped(sender: UITapGestureRecognizer) {
        configureSelect(type: .myTopic)
    }
    
    @objc func aboutTapped(sender: UITapGestureRecognizer) {
        configureSelect(type: .about)
    }
    
    @objc func settingTapped(sender: UITapGestureRecognizer) {
        configureSelect(type: .setting)
    }
    
    @objc func loginStatusChangedHandler(notification: Notification) {
        loginStatusChanged()
    }
    
    @objc func unitNodeSelectHandler(notification: Notification) {
        selectedButton = topicListButton
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

