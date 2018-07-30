//
//  LoginViewController.swift
//  Material-V2EX
//
//  Created by altair21 on 17/2/8.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    @IBOutlet weak var authTextField: ErrorTextField!
    @IBOutlet weak var authImageView: UIImageView!
    @IBOutlet weak var closeButton: FABButton!
    @IBOutlet weak var loginButton: RaisedButton!
    @IBOutlet weak var authIndicator: UIActivityIndicatorView!
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    var once = ""
    var userSHA = ""
    var pwdSHA = ""
    var authSHA = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        authTextField.delegate = self
        
        let tapAuthImg = UITapGestureRecognizer(target: self, action: #selector(authImgTapped(sender:)))
        authImageView.addGestureRecognizer(tapAuthImg)
        
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        
        self.requestAuthImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func requestAuthImage() {
        NetworkManager.shared.prepareForLogin(success: {(once, userSHA, pwdSHA, authSHA, imageData) in
            self.once = once
            self.userSHA = userSHA
            self.pwdSHA = pwdSHA
            self.authSHA = authSHA
            self.authImageView.image = UIImage(data: imageData)
            
            self.authImageView.alpha = 1
            self.authImageView.isUserInteractionEnabled = true
            self.authIndicator.isHidden = true
        }, failure: {(error) in
            let _ = ToastManager.shared.showCustomToast(toView: self.view, text: error, customView: UIImageView(image: UIImage(named: "failure")))
        })
    }
    
    func setupGesture() {
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(closeTapped(sender:)))
        closeButton.addGestureRecognizer(tapClose)
        
        let tapLogin = UITapGestureRecognizer(target: self, action: #selector(loginTapped(sender:)))
        loginButton.addGestureRecognizer(tapLogin)
    }
    
    @objc func closeTapped(sender: UITapGestureRecognizer) {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
    
    @objc func loginTapped(sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        authTextField.resignFirstResponder()
        
        if usernameTextField.text?.count == 0 {
            usernameTextField.isErrorRevealed = true
        }
        if passwordTextField.text?.count == 0 {
            passwordTextField.isErrorRevealed = true
        }
        if authTextField.text?.count == 0 {
            authTextField.isErrorRevealed = true
        }
        if usernameTextField.text?.count == 0 || passwordTextField.text?.count == 0 || authTextField.text?.count == 0 {
            return
        }
        
        let hud = ToastManager.shared.showToast(toView: self.view, text: "正在登录", mode: .indeterminate)
        NetworkManager.shared.loginWith(once: once, userSHA: userSHA, pwdSHA: pwdSHA, authSHA: authSHA, username: usernameTextField.text!, password: passwordTextField.text!, auth: authTextField.text!, success: { (username, avatarURL) in
            hud.hide(animated: true)
            User.shared.setLogin(username: username, avatarURL: avatarURL)
            self.modalDelegate?.modalViewControllerDismiss(callbackData: nil)
        }) { (error) in
            hud.hide(animated: true)
            let _ = ToastManager.shared.showCustomToast(toView: self.view, text: error, customView: UIImageView(image: UIImage(named: "failure")))
        }
    }
    
    @IBAction func textChanged(_ sender: TextField) {
        (sender as? ErrorTextField)?.isErrorRevealed = false
    }
    
    @objc func authImgTapped(sender: UITapGestureRecognizer) {
        authImageView.alpha = 0.6
        authImageView.isUserInteractionEnabled = false
        print("tap test")
        authIndicator.isHidden = false
        self.requestAuthImage()
    }
}

// MARK: TextFieldDelegate
extension LoginViewController: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            let _ = passwordTextField.becomeFirstResponder()
            return false
        } else if textField == passwordTextField {
            let _ = authTextField.becomeFirstResponder()
            return false
        } else if textField == authTextField {
            loginTapped(sender: UITapGestureRecognizer())
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
}

