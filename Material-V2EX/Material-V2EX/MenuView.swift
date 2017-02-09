//
//  menuView.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/21.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD

class MenuView: UIView {
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var panelViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var mainButton: RaisedButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let shared = Bundle.main.loadNibNamed(Global.Views.menuView, owner: nil, options: nil)?.first as! MenuView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        let bgView = UIImageView(image: UIImage(named: "menuview_bg"))
        bgView.frame = panelView.frame
        self.panelView.layer.insertSublayer(bgView.layer, at: 0)
        self.avatarView.layer.borderColor = UIColor.white.cgColor
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginStatusChanged),
                                               name: Global.Notifications.kLoginStatusChanged,
                                               object: nil)
        
        setupGesture()
    }
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backHome(sender:)))
        bgView.addGestureRecognizer(tap)
        
        let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(handlePanel(sender:)))
        self.addGestureRecognizer(swipeLeft)
        
        let tapMainBtn = UITapGestureRecognizer(target: self, action: #selector(mainButtonTapped(sender:)))
        mainButton.addGestureRecognizer(tapMainBtn)
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
            
            let toast = MBProgressHUD.showAdded(to: (UIApplication.shared.keyWindow?.rootViewController?.view)!, animated: true)
            toast.bezelView.color = UIColor.black
            toast.contentColor = UIColor.white
            toast.mode = .text
            toast.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
            toast.label.text = "账号已注销"
            toast.hide(animated: true, afterDelay: Global.Config.toastDuration)
        } else {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Global.ViewControllers.login) as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController?.present(loginViewController, animated: true, completion: nil)
        }
        
    }
    
    func loginStatusChanged(notification: Notification) {
        usernameLabel.text = User.shared.username
        
        if User.shared.avatarURL.characters.count > 0 {
            avatarView.setImageWith(url: User.shared.avatarURL)
        } else {
            avatarView.image = UIImage(named: "default_avatar")
        }
        
        mainButton.titleLabel?.text = User.shared.isLogin ? "登出" : "登录"
    }
}

