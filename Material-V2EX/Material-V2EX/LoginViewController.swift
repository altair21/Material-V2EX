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
    @IBOutlet weak var closeButton: FABButton!
    @IBOutlet weak var loginButton: RaisedButton!
    
    weak var modalDelegate: ModalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
        
        if usernameTextField.text?.characters.count == 0 {
            usernameTextField.isErrorRevealed = true
        }
        if passwordTextField.text?.characters.count == 0 {
            passwordTextField.isErrorRevealed = true
        }
        if usernameTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0 {
            return
        }
        
        let hud = ToastManager.shared.showToast(toView: self.view, text: "正在登录", mode: .indeterminate)
        NetworkManager.shared.loginWith(username: usernameTextField.text!, password: passwordTextField.text!, success: { (username, avatarURL) in
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
}

// MARK: TextFieldDelegate
extension LoginViewController: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            return false
        } else if textField == passwordTextField {
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

